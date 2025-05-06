// 波浪动画效果
function createWaveAnimation() {
    // 创建样式
    const style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = `
        .vh-bolang {
            pointer-events: none;
            position: fixed;
            left: 0px;
            bottom: 0px;
            width: 100vw;
            height: 88px;
            z-index: 1;
        }
        .vh-bolang-main > use {
            animation: vh-bolang-item-move 12s linear infinite;
        }
        .vh-bolang-main > use:nth-child(1) {
            animation-delay: -2s;
        }
        .vh-bolang-main > use:nth-child(2) {
            animation-delay: -2s;
            animation-duration: 5s;
        }
        .vh-bolang-main > use:nth-child(3) {
            animation-delay: -4s;
            animation-duration: 3s;
        }
        @keyframes vh-bolang-item-move {
            0% {
                transform: translate(-90px, 0);
            }
            100% {
                transform: translate(85px, 0);
            }
        }
    `;
    document.head.appendChild(style);

    // 创建SVG元素
    const svgString = `
        <svg class="vh-bolang" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 24 150 28" preserveAspectRatio="none">
            <defs>
                <path id="vh-bolang-item" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z"></path>
            </defs>
            <g class="vh-bolang-main">
                <use xlink:href="#vh-bolang-item" x="50" y="0" fill="rgba(224,233,239,.5)"></use>
                <use xlink:href="#vh-bolang-item" x="50" y="3" fill="rgba(224,233,239,.5)"></use>
                <use xlink:href="#vh-bolang-item" x="50" y="6" fill="rgba(224,233,239,.5)"></use>
            </g>
        </svg>
    `;

    // 解析SVG并添加到页面
    const parser = new DOMParser();
    const svgElement = parser.parseFromString(svgString, 'image/svg+xml').querySelector('svg');
    document.body.appendChild(svgElement);
}

// 控制台信息
function showConsoleInfo() {
    console.log('%c 作者信息', 'color: #ffffff; background: #6666FF; padding:5px');
    console.log('%c Ljz博客 oini.de', 'color: #fadfa3; background: #030307; padding:5px');
    console.log('%c 欢迎前来围观、吐槽、点赞、学习......', 'color: #fadfa3; background: #030307; padding:5px');
    console.log('%c -', 'color: #ffffff; background: #6666FF; padding:5px');
    console.log('%c 风是自由的 希望你也是.', 'color: #fadfa3; background: #030307; padding:5px');
}

// 确保代码只执行一次
if (!window.waveInitialized) {
    window.waveInitialized = true;

    // 处理页面加载
    if (window.onload) {
        const oldOnload = window.onload;
        window.onload = function() {
            createWaveAnimation();
            oldOnload();
        };
    } else {
        window.onload = createWaveAnimation;
    }

    // 显示控制台信息
    showConsoleInfo();
}
