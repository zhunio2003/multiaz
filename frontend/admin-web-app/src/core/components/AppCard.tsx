import styles from './AppCard.module.css'

interface Props {
    children: React.ReactNode,
    className?: string
}

const AppCard = ({ children, className}: Props) => {
    return (
        <div className={`${className || ''} ${styles.card}`}>
            {children}
        </div>
    )
}

export default AppCard;