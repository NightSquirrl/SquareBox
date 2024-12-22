import axios, { InternalAxiosRequestConfig, AxiosResponse, AxiosError } from '@ohos/axios'

export const http = axios.create({
  baseURL: 'http://wts.s.odn.cc/api'
})

// 添加请求拦截器
http.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => config,
  (error: AxiosError) => {
    // toast.warning(error.message ?? '未知请求错误')
    // 对请求错误做些什么
    return Promise.reject(error);
  },
)

// 添加响应拦截器
http.interceptors.response.use(
  (response: AxiosResponse) => {
    if (response.data) {
      return response.data
    }
    return response
  },
  (error: AxiosError) => {
    const status = error.response?.status;
    // let { msg, message } = (error.response?.data)
    // if (!msg && message) {
    //   msg = message;
    // }
    // if (!msg) {
    //   switch (status) {
    //     case 400:
    //       msg = '参数错误';
    //       break;
    //     case 500:
    //       msg = '服务端错误';
    //       break;
    //     case 404:
    //       msg = '路由未找到';
    //       break;
    //     default:
    //       msg = error.message ?? '未知响应错误';
    //       break;
    //   }
    // }
    // toast.warning(msg)
    // 超出 2xx 范围的状态码都会触发该函数。
    // 对响应错误做点什么
    return Promise.reject(error);
  },
)