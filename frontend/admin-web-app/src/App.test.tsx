import { render} from '@testing-library/react'
import App from './App'

describe("App", () => {
    it('render within crashing', () => {
        render(<App />)
        expect(document.body).toBeTruthy()
    })
})  