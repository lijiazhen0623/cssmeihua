// 雪花效果
function createSnow() {
    // 创建样式
    const style = document.createElement('style');
    style.innerHTML = `
        #hanApi-Snow {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 99999;
            pointer-events: none;
        }
    `;
    document.head.appendChild(style);

    // 创建画布
    const canvas = document.createElement('canvas');
    canvas.id = 'hanApi-Snow';
    document.body.appendChild(canvas);

    // 获取画布上下文
    const ctx = canvas.getContext('2d');
    const snowflakes = [];
    const snowflakeCount = 66;
    let mouseX = -100;
    let mouseY = -100;

    // 动画函数
    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        for (let i = 0; i < snowflakeCount; i++) {
            const snow = snowflakes[i];
            const dx = mouseX - snow.x;
            const dy = mouseY - snow.y;
            const distance = Math.sqrt(dx * dx + dy * dy);

            // 鼠标交互效果
            if (distance < 150) {
                const forceX = dx / distance;
                const forceY = dy / distance;
                const force = 150 / (distance * distance) / 2;
                snow.velX -= force * forceX;
                snow.velY -= force * forceY;
            } else {
                snow.velX *= 0.98;
                if (snow.velY <= snow.speed) {
                    snow.velY = snow.speed;
                }
                snow.velX += Math.cos(snow.step += 0.05) * snow.stepSize;
            }

            // 绘制雪花
            ctx.fillStyle = `rgba(255, 255, 255, ${snow.opacity})`;
            snow.y += snow.velY;
            snow.x += snow.velX;

            // 边界检查
            if (snow.y >= canvas.height || snow.y <= 0) {
                resetSnow(snow);
            }
            if (snow.x >= canvas.width || snow.x <= 0) {
                resetSnow(snow);
            }

            // 绘制雪花
            ctx.beginPath();
            ctx.arc(snow.x, snow.y, snow.size, 0, 2 * Math.PI);
            ctx.fill();
        }

        requestAnimationFrame(animate);
    }

    // 重置雪花
    function resetSnow(snow) {
        snow.x = Math.floor(Math.random() * canvas.width);
        snow.y = 0;
        snow.size = 3 * Math.random() + 2;
        snow.speed = 1 * Math.random() + 0.2;
        snow.velY = snow.speed;
        snow.velX = 0;
        snow.opacity = 0.5 * Math.random() + 0.3;
    }

    // 设置画布尺寸
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    // 鼠标移动事件
    document.addEventListener('mousemove', function(e) {
        mouseX = e.clientX;
        mouseY = e.clientY;
    });

    // 窗口大小改变事件
    window.addEventListener('resize', function() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    });

    // 初始化雪花
    function initSnow() {
        for (let i = 0; i < snowflakeCount; i++) {
            const x = Math.floor(Math.random() * canvas.width);
            const y = Math.floor(Math.random() * canvas.height);
            const size = 3 * Math.random() + 2;
            const speed = 1 * Math.random() + 0.2;
            const opacity = 0.5 * Math.random() + 0.3;

            snowflakes.push({
                speed: speed,
                velY: speed,
                velX: 0,
                x: x,
                y: y,
                size: size,
                stepSize: Math.random() / 30 * 1,
                step: 0,
                angle: 180,
                opacity: opacity
            });
        }
        animate();
    }

    // 启动动画
    initSnow();
}

// 确保requestAnimationFrame在所有浏览器中可用
window.requestAnimationFrame = window.requestAnimationFrame || 
    window.mozRequestAnimationFrame || 
    window.webkitRequestAnimationFrame || 
    window.msRequestAnimationFrame || 
    function(callback) {
        window.setTimeout(callback, 1000 / 60);
    };

// 页面加载完成后初始化
if (window.onload) {
    const oldOnload = window.onload;
    window.onload = function() {
        createSnow();
        oldOnload();
    };
} else {
    window.onload = createSnow;
}

// 控制台信息
if (typeof vhApiConsoleLog !== 'function') {
    var vhApiConsoleLog = () => {
        console.log('%c 作者信息', 'color: #ffffff; background: #6666FF; padding:5px');
        console.log('%c Ljz博客 oini.de', 'color: #fadfa3; background: #030307; padding:5px');
        console.log('%c 欢迎前来围观、吐槽、点赞、学习......', 'color: #fadfa3; background: #030307; padding:5px');
        console.log('%c -', 'color: #ffffff; background: #6666FF; padding:5px');
        console.log('%c 风是自由的 希望你也是.', 'color: #fadfa3; background: #030307; padding:5px');
        console.groupEnd();
    };
    vhApiConsoleLog();
} 
