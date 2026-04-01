import styles from './SideBar.module.css'

interface Props {
    children: React.ReactNode
}

const SideBar = ({ children}: Props) => {
    return (
        <div className={styles.sidebar}>
            {children}
        </div>
    )
}

export default SideBar;