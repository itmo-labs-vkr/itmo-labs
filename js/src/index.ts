import {App} from './app';

const app = new App({
    container: 'root',
    width: window.innerWidth * 0.9,
    height: window.innerHeight * 0.8,
});

app.run();
