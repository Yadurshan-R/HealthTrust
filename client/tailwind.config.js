/** @type {import('tailwindcss').Config} */
export default {
    darkMode: 'class', // Enable class-based dark mode
    content: [
        "./index.html",
        "./src/**/*.{vue,js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                'main-blue': '#264a70',
                'main-green': '#11998e',
                'accent-orange': '#e97d30',
                'secondary-blue': '#495a6c',
                'light-gray': '#f0f4f8',
                'dark-gray': '#a5b0b9',
                'success-green': '#10b981',
                'danger-red': '#ef4444',
                'warning-yellow': '#f59e0b',
            },
            fontFamily: {
                sans: ['Inter', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
            },
            boxShadow: {
                'card': '0 1px 3px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.04)',
                'card-hover': '0 10px 25px rgba(0, 0, 0, 0.08)',
            },
            borderRadius: {
                'card': '12px',
            },
            spacing: {
                '18': '4.5rem',
            },
        },
    },
    plugins: [],
}
