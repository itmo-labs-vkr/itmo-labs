import {BaseHTMLComponent} from '../base';
import {div} from '../utils';
import './styles.css';

type Props = {
    text: string;
    buttons?: {
        content: string;
        action(): void;
        color?: string;
    }[];
};

const popup = (text: string, buttons?: string) => {
    return `\
    <div class="popup-element">
       <div class="popup-content">
       <div class="popup-close">&#x2715;</div>
        ${div(text, 'title')}
        ${div(buttons, 'buttons')}
       </div>
    </div>    
`;
};

export class HTMLPopup extends BaseHTMLComponent<Props> {
    template(): string {
        const {text} = this.props;

        setTimeout(() => {
            const close = document.querySelector('.popup-close') as HTMLElement;

            close?.addEventListener('click', () => {
                this.unmount();
            });
        });

        return popup(text);
    }
}
