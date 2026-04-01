import styles from './AppTextField.module.css'

interface Props {
    value: string,
    onChange: (value: string) => void
    placeholder?: string
    error?: string
}

const AppTextField = ({ value, onChange, placeholder, error }: Props) => {
    return (
        <div>
            <input 
                className={styles.input}
                value={value}
                onChange={(e) => onChange(e.target.value)} 
                placeholder={placeholder}
            />
            {error && <span className={styles.error}>{error}</span>}
        </div>
    )
}

export default AppTextField;