import styles from './SecondaryButton.module.css'

interface Props {
    label: string,
    onClick: () => void
    disabled?: boolean
}

const SecondaryButton = ({ label, onClick, disabled = false }: Props) => {
    return (
        <button 
            className={styles.button}
            onClick={onClick} 
            disabled={disabled}
            style={{
                opacity: disabled? 0.5: 1,
                cursor: disabled? 'not-allowed': 'pointer' 
            }}
        >
            {label}
        </button>
    )
}

export default SecondaryButton;