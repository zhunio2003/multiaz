import axios from "axios"

export class NetworkError extends Error {

    constructor(message: string) {
        super(message)
        this.name = 'NetworkError'
    }
    
    static fromAxiosError(error: unknown): NetworkError {
        if (axios.isAxiosError(error)) {
            if (error.code === 'ECONNABORTED') {
                return new NetworkError('The server took too long to respond')
            }
            if (!error.response) {
                return new NetworkError('No internet connection')
            }
            if (error.response.status >= 500) {
                return new NetworkError(`Server error: ${error.response.status}`)
            }
        }
        return new NetworkError('An unexcepted error occurred')
        
    }
}