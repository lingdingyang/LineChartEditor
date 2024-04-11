# line chart editor
## 项目介绍
- Controller对象实现了一系列槽方法用于qml调用，定义了一系列信号通知qml执行相应方法
- 在main.cpp 实例化一个Controller对象，通过 *setContextProperty* 方法传递到qml中使用
- qml中使用QtCharts中LineSeries绘制折线，通过ScatterSeries在相应位置绘制点实现选中点高亮效果
## 使用方法
- 项目执行后点击打开文件，选择文件后显示出折线图
- 通过鼠标移动选择相应点，选中相应点后输入修改值并点击按钮完成指定点的修改
- 选中相应点后点击删除按钮实现删除指定点
## 注意
- 只实现了固定显示两条折线，需要确保输入文件为四行
- 打包只拷贝了需要的dll等，可执行文件需要再解压后的目录运行
