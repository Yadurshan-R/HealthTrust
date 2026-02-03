import { toast } from 'vue3-toastify';

export function useToast() {
    const showSuccess = (message, options = {}) => {
        toast.success(message, {
            position: 'top-right',
            autoClose: 3000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            ...options,
        });
    };

    const showError = (message, options = {}) => {
        toast.error(message, {
            position: 'top-right',
            autoClose: 4000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            ...options,
        });
    };

    const showInfo = (message, options = {}) => {
        toast.info(message, {
            position: 'top-right',
            autoClose: 3000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            ...options,
        });
    };

    const showWarning = (message, options = {}) => {
        toast.warning(message, {
            position: 'top-right',
            autoClose: 3000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            ...options,
        });
    };

    return {
        showSuccess,
        showError,
        showInfo,
        showWarning,
    };
}
