import axios from "axios";

const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_GATEWAY_URL,
    timeout: 30000,
    headers: {
        'Content-Type': 'application/json'
    },

})

const refreshClient = axios.create({
    baseURL: import.meta.env.VITE_API_GATEWAY_URL,
    timeout: 30000,
    headers: {
        'Content-Type': 'application/json'
    }
})

apiClient.interceptors.request.use((config) => {
    const token = localStorage.getItem('accessToken')
    if(token) {
        config.headers.Authorization = `Bearer ${token}`
    }
    return config 
});

apiClient.interceptors.response.use(
    (response) => response,
    async (error) => {
        const originalRequest = error.config

        if (error.response?.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true

            const refreshToken = localStorage.getItem('refreshToken')
            
            

            if (refreshToken) {

                try {
                    const response = await refreshClient.post('/auth/refresh', {refreshToken})

                    localStorage.setItem('accessToken', response.data.accessToken)
                    
                    originalRequest.headers.Authorization = `Bearer ${response.data.accessToken}`

                    return refreshClient.request(originalRequest)

                } catch (error) {
                    localStorage.removeItem('accessToken')
                    localStorage.removeItem('refreshToken')
                    return Promise.reject(error)
                }

            }
        }
    }
)



export default apiClient;