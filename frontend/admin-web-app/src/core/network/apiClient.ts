import axios from "axios";

const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_GATEWAY_URL,
    timeout: 30000,
    headers: {
        'Content-Type': 'application/json'
    },

})

export default apiClient;