#include "sgdmomentum.h"

template<typename T>
SGDMomentum<T>::SGDMomentum(){

}

template<typename T>
tuple<Tensor<T>, Tensor<T> > SGDMomentum<T>::Optimize(const Tensor<T> &params, const Tensor<T> &grad_params, const Tensor<T> &state){
    cout << "SGDMomentum optimizer" << endl;
    Tensor<T> A(vector<int>({1,2}),{0,0});
    Tensor<T> B(vector<int>({1,2}),{0,0});
    return make_tuple(A,B);
}

/*
 * Explicit declare template versions to avoid linker error. (This is needed if we use templates on .cpp files)
*/
template class SGDMomentum<float>;
template class SGDMomentum<double>;
template class SGDMomentum<int>;