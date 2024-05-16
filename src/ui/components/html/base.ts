import {state} from '@labs/state';

export class BaseHTMLComponent<Props> {
    protected props: Props;
    protected container!: HTMLElement;

    constructor(props: Props) {
        this.props = props;
    }

    render(at?: Point2D) {
        const html = this.template();
        const {client} = state.config();

        if (this.container) {
            this.container.remove();
        }

        this.container = document.createElement('div');

        this.container.innerHTML = html;

        if (at) {
            this.container.style.position = 'absolute';
            this.container.style.zIndex = '10000';
            const x = at.x + client.left;
            const y = at.y + client.top;

            this.container.style.top = `${y}px`;
            this.container.style.left = `${x}px`;
        }

        document.body.appendChild(this.container);
    }

    template(): string {
        throw new Error('Method `template` should be implemented in child class');
    }

    unmount() {
        this.container.remove();
    }
}
