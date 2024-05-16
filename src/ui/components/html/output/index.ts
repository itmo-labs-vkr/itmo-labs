import {BaseHTMLComponent} from '../base';
import {div} from '../utils';
import './styles.css';

type Props = {
    title?: string;
    values: unknown;
};

export class HTMLOutput extends BaseHTMLComponent<Props> {
    template(): string {
        const {values, title} = this.props;
        const value = JSON.stringify(values, null, 4);

        if (value === '{}') {
            return '';
        }

        return `\
        <div class="output-container">
            ${div(title)}
            ${div(value)}
        </div>
    `;
    }
}
