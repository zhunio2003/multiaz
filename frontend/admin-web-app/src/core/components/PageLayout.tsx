import type React from 'react';
import styles from './PageLayout.module.css'

interface Props {
    sidebar: React.ReactNode,
    children: React.ReactNode
}

const PageLayout = ({ sidebar, children}: Props) => {
    return (
        <div className={styles.layout}>
            {sidebar}
            <main className={styles.content}>
                {children}
            </main>
        </div>
    )
}

export default PageLayout;