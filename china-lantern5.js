// 创建样式元素
function createStyleElement() {
    const style = document.createElement('style');
    style.setAttribute('type', 'text/css');
    style.innerHTML = `
        .vvhan-com-denglong4 {position: fixed; top: -40px; right: 150px; z-index: 9999; pointer-events: none;}
        .vvhan-com-denglong3 {position: fixed; top: -30px; right: 10px; z-index: 9999; pointer-events: none;}
        .vvhan-com-denglong1 {position: fixed; top: -40px; left: 150px; z-index: 9999; pointer-events: none;}
        .vvhan-com-denglong2 {position: fixed; top: -30px; left: 10px; z-index: 9999; pointer-events: none;}
        
        .vvhan-com-denglong3 .vvhan-com-denglong,
        .vvhan-com-denglong2 .vvhan-com-denglong {
            position: relative;
            width: 120px;
            height: 90px;
            margin: 50px;
            background: #d8000f;
            background: rgba(216, 0, 15, 0.8);
            border-radius: 50% 50%;
            -webkit-transform-origin: 50% -100px;
            -webkit-animation: swing 5s infinite ease-in-out;
            box-shadow: -5px 5px 30px 4px #fc903d;
        }
        
        .vvhan-com-denglong {
            position: relative;
            width: 120px;
            height: 90px;
            margin: 50px;
            background: #d8000f;
            background: rgba(216, 0, 15, 0.8);
            border-radius: 50% 50%;
            -webkit-transform-origin: 50% -100px;
            -webkit-animation: swing 3s infinite ease-in-out;
            box-shadow: -5px 5px 50px 4px #fa6c00;
        }
        
        .vvhan-com-denglong-a {
            width: 100px;
            height: 90px;
            background: #d8000f;
            background: rgba(216, 0, 15, 0.1);
            margin: 12px 8px 8px 8px;
            border-radius: 50% 50%;
            border: 2px solid #dc8f03;
        }
        
        .vvhan-com-denglong-b {
            width: 45px;
            height: 90px;
            background: #d8000f;
            background: rgba(216, 0, 15, 0.1);
            margin: -4px 8px 8px 26px;
            border-radius: 50% 50%;
            border: 2px solid #dc8f03;
        }
        
        .vvhan-com-sui {
            position: absolute;
            top: -20px;
            left: 60px;
            width: 2px;
            height: 20px;
            background: #dc8f03;
        }
        
        .vvhan-com-sui-a {
            position: relative;
            width: 5px;
            height: 20px;
            margin: -5px 0 0 59px;
            -webkit-animation: swing 4s infinite ease-in-out;
            -webkit-transform-origin: 50% -45px;
            background: orange;
            border-radius: 0 0 5px 5px;
        }
        
        .vvhan-com-sui-c {
            position: absolute;
            top: 14px;
            left: -2px;
            width: 10px;
            height: 10px;
            background: #dc8f03;
            border-radius: 50%;
        }
        
        .vvhan-com-sui-b {
            position: absolute;
            top: 18px;
            left: -2px;
            width: 10px;
            height: 35px;
            background: orange;
            border-radius: 0 0 0 5px;
        }
        
        .vvhan-com-denglong:before {
            position: absolute;
            top: -7px;
            left: 29px;
            height: 12px;
            width: 60px;
            content: " ";
            display: block;
            z-index: 999;
            border-radius: 5px 5px 0 0;
            border: solid 1px #dc8f03;
            background: orange;
            background: linear-gradient(to right,#dc8f03,orange,#dc8f03,orange,#dc8f03);
        }
        
        .vvhan-com-denglong:after {
            position: absolute;
            bottom: -7px;
            left: 10px;
            height: 12px;
            width: 60px;
            content: " ";
            display: block;
            margin-left: 20px;
            border-radius: 0 0 5px 5px;
            border: solid 1px #dc8f03;
            background: orange;
            background: linear-gradient(to right,#dc8f03,orange,#dc8f03,orange,#dc8f03);
        }
        
        .vvhan-com-denglong-c {
            font-family: 黑体, Arial, Lucida Grande, Tahoma, sans-serif;
            font-size: 3.2rem;
            color: #dc8f03;
            font-weight: 700;
            line-height: 85px;
            text-align: center;
        }
        
        .night .vvhan-com-denglong4,
        .night .vvhan-com-denglong3,
        .night .vvhan-com-denglong-c {
            background: 0 0 !important;
        }
        
        @-moz-keyframes swing {
            0% {-moz-transform: rotate(-10deg);}
            50% {-moz-transform: rotate(10deg);}
            100% {-moz-transform: rotate(-10deg);}
        }
        
        @-webkit-keyframes swing {
            0% {-webkit-transform: rotate(-10deg);}
            50% {-webkit-transform: rotate(10deg);}
            100% {-webkit-transform: rotate(-10deg);}
        }
    `;
    document.querySelector('head').appendChild(style);
}

// 创建灯笼HTML结构
function createLanternHTML() {
    const div = document.createElement('div');
    div.innerHTML = `
        <div class="vvhan-com-denglong1">
            <div class="vvhan-com-denglong">
                <div class="vvhan-com-sui"></div>
                <div class="vvhan-com-denglong-a">
                    <div class="vvhan-com-denglong-b">
                        <div class="vvhan-com-denglong-c">年</div>
                    </div>
                </div>
                <div class="shui vvhan-com-sui-a">
                    <div class="vvhan-com-sui-b"></div>
                    <div class="vvhan-com-sui-c"></div>
                </div>
            </div>
        </div>
        <div class="vvhan-com-denglong2">
            <div class="vvhan-com-denglong">
                <div class="vvhan-com-sui"></div>
                <div class="vvhan-com-denglong-a">
                    <div class="vvhan-com-denglong-b">
                        <div class="vvhan-com-denglong-c">新</div>
                    </div>
                </div>
                <div class="shui vvhan-com-sui-a">
                    <div class="vvhan-com-sui-b"></div>
                    <div class="vvhan-com-sui-c"></div>
                </div>
            </div>
        </div>
        <div class="vvhan-com-denglong3">
            <div class="vvhan-com-denglong">
                <div class="vvhan-com-sui"></div>
                <div class="vvhan-com-denglong-a">
                    <div class="vvhan-com-denglong-b">
                        <div class="vvhan-com-denglong-c">乐</div>
                    </div>
                </div>
                <div class="shui vvhan-com-sui-a">
                    <div class="vvhan-com-sui-b"></div>
                    <div class="vvhan-com-sui-c"></div>
                </div>
            </div>
        </div>
        <div class="vvhan-com-denglong4">
            <div class="vvhan-com-denglong">
                <div class="vvhan-com-sui"></div>
                <div class="vvhan-com-denglong-a">
                    <div class="vvhan-com-denglong-b">
                        <div class="vvhan-com-denglong-c">快</div>
                    </div>
                </div>
                <div class="shui vvhan-com-sui-a">
                    <div class="vvhan-com-sui-b"></div>
                    <div class="vvhan-com-sui-c"></div>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(div);
}

// 初始化灯笼
function initLantern() {
    createStyleElement();
    createLanternHTML();
}

// 控制台输出信息
function showConsoleInfo() {
    console.log('%c 作者信息', 'color: #ffffff; background: #6666FF; padding:5px');
    console.log('%c Ljz博客 oini.de', 'color: #fadfa3; background: #030307; padding:5px');
    console.log('%c 欢迎前来围观、吐槽、点赞、学习......', 'color: #fadfa3; background: #030307; padding:5px');
    console.log();
    console.log('%c -', 'color: #ffffff; background: #6666FF; padding:5px');
    console.log('%c 风是自由的 希望你也是.', 'color: #fadfa3; background: #030307; padding:5px');
    console.log();
}

// 页面加载完成后初始化
if (window.onload) {
    const oldOnload = window.onload;
    window.onload = function() {
        initLantern();
        oldOnload();
    };
} else {
    window.onload = initLantern;
}

// 显示控制台信息
showConsoleInfo(); 
