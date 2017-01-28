classdef ConvolutionLayer < BaseLayer
    %ConvolutionLayer Summary of this class goes here
    % Reference:
    % https://github.com/leonardoaraujosantos/DLMatFramework/blob/master/learn/cs231n/assignment2/cs231n/layers.py
    % https://leonardoaraujosantos.gitbooks.io/artificial-inteligence/content/convolution_layer.html
    
    properties (Access = 'protected')
        weights
        biases
        activations
        config
        previousInput
        name
        index
        activationShape
        inputLayer
        numOutput
        
        % Some data used for convolution
        m_kernelHeight
        m_kernelWidth
        m_stride
        m_padding
    end
    
    methods (Access = 'public')
        function [obj] = ConvolutionLayer(name, kH, kW, stride, pad,index, inLayer)
            obj.name = name;
            obj.index = index;
            %obj.numOutput = numOutput;
            obj.inputLayer = inLayer;
            %obj.activationShape = [1 numOutput];
            obj.m_kernelHeight = kH;
            obj.m_kernelHeight = kW;
            obj.m_stride = stride;
            obj.m_padding = pad;
        end
        
        function [activations] = ForwardPropagation(obj, input, weights, bias)
            % Tensor format (rows,cols,channels, batch) on matlab
            [H,W,~,N] = size(input);
            [HH,WW,C,F] = size(weights);
            
            % Calculate output sizes
            H_prime = (H+2*obj.m_padding-HH)/obj.m_stride +1;
            W_prime = (W+2*obj.m_padding-WW)/obj.m_stride +1;
            
            % Alocate memory for output
            activations = zeros([H_prime,W_prime,F,N]);
            
            % Preparing filter weights
            filter_col = reshape(w,[HH*WW*C F]);
            filter_col = filter_col';
            
            % Preparing bias
            if ~isempty(bias)
                bias = repmat(bias,[1 H_prime*W_prime]);
            else
                b = single(zeros(size(filter_col,1),1));
                bias = repmat(b,[1 H_prime*W_prime]);
            end
            
            % Here we convolve each image on the batch in a for-loop, but the im2col
            % could also handle a image batch at the input, so all computations would
            % be just one big matrix multiplication. We opted now for this to test the
            % par-for implementation with OpenMP on CPU
            for idxBatch = 1:N
                im = input(:,:,:,idxBatch);    
                im_col = im2col_ref(im,HH,WW,stride,pad_num,1);
                mul = (filter_col * im_col) + bias;
                activations(:,:,:,ii) =  reshape_row_major(mul,[H_prime W_prime size(mul,1)]);
            end
            
            
            % Cache results for backpropagation
            obj.activations = activations;
            obj.weights = weights;
            obj.biases = bias;
            obj.previousInput = input;
        end
        
        function [gradient] = BackwardPropagation(obj, dout)
            dout = dout.input;
            % Recover cache
            lenSizeActivations = length(size(obj.previousInput));
            if (lenSizeActivations < 3)
                N = size(obj.previousInput,1);
            else
                N = size(obj.previousInput,ndims(obj.previousInput));
            end
            
            
            
            if obj.doGradientCheck
                evalGrad = obj.EvalBackpropNumerically(dout);
                diff_Input = sum(abs(evalGrad.input(:) - gradient.input(:)));
                diff_Weights = sum(abs(evalGrad.weight(:) - gradient.weight(:)));
                diff_Bias = sum(abs(evalGrad.bias(:) - gradient.bias(:)));
                diff_vec = [diff_Input diff_Weights diff_Bias]; % diff_Bias
                diff = sum(diff_vec);
                if diff > 0.0001
                    msgError = sprintf('%s gradient failed!\n',obj.name);
                    error(msgError);
                else
                    %fprintf('%s gradient passed!\n',obj.name);
                end
            end
        end
        
        function [numOut] = getNumOutput(obj)
            numOut = obj.numOutput;
        end
        
        function gradient = EvalBackpropNumerically(obj, dout)
            % Fully connected layers has 3 inputs so we have 3 gradients
            convProp_x = @(x) obj.ForwardPropagation(x,obj.weights, obj.biases);
            convProp_w = @(x) obj.ForwardPropagation(obj.previousInput,x, obj.biases);
            convProp_b = @(x) obj.ForwardPropagation(obj.previousInput,obj.weights, x);
            
            % Evaluate
            gradient.input = GradientCheck.Eval(convProp_x,obj.previousInput,dout);
            gradient.weight = GradientCheck.Eval(convProp_w,obj.weights,dout);
            gradient.bias = GradientCheck.Eval(convProp_b,obj.biases, dout);
        end
    end
    
end

