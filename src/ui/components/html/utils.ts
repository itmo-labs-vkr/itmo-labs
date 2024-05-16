export const div = (content?: string, ...classList: string[]) => {
    if (!content) {
        return '';
    }

    return `<div class="${classList.join(' ')}">${content}</div>`;
};
