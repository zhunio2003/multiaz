import axios from "axios";

const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_GATEWAY_URL,
    timeout: 30000,
    headers: {
        'Content-Type': 'application/json'
    },

})

apiClient.interceptors.request.use((config) => {
    const token = localStorage.getItem('accessToken')
    if(token) {
        config.headers.Authorization = `Bearer ${token}`
    }
    return config 
});

export default apiClient;