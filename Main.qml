import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtCharts

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Button {
        id: openFileButton
        x: 0 // 设置按钮的横坐标
        y: 5 // 设置纵坐标
        text: "打开文件" // 按钮文本
        width: 150
        height: 50
        // 信号槽连接
        onClicked: {
            fileDialog.open()
        }
        font.pixelSize: 25
    }
    Label {
        id: labX
        x: openFileButton.width + 5
        y: 5
        height: 50
        text: "x="
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 25
    }
    TextInput {
        function inputUpdate() {
            if (handler.selectedLine === -1 || handler.selectedPoint === -1) {
                editX.enabled = false
                editX.text = "未选择点"
                return
            }
            editX.enabled = true
            if (handler.selectedLine === 1) {
                editX.text = handler.x1[handler.selectedPoint]
            } else {
                editX.text = handler.x2[handler.selectedPoint]
            }
        }

        enabled: false
        id: editX
        x: openFileButton.width + labX.width + 10
        y: 5
        height: 50
        text: "未选择点"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 25
    }

    Label {
        id: labY
        x: openFileButton.width + editX.width + labX.width + 15
        y: 5
        height: 50
        text: "y="
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 25
    }

    TextInput {
        function inputUpdate() {
            if (handler.selectedLine === -1 || handler.selectedPoint === -1) {
                editY.enabled = false
                editY.text = "未选择点"
                return
            }
            editY.enabled = true
            if (handler.selectedLine === 1) {
                editY.text = handler.y1[handler.selectedPoint]
            } else {
                editY.text = handler.y2[handler.selectedPoint]
            }
        }
        enabled: false
        id: editY
        x: openFileButton.width + editX.width + labX.width + labY.width + 20
        y: 5
        height: 50
        text: "未选择点"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 25
    }
    Button {
        id: btnEdit
        x: openFileButton.width + editX.width + labX.width + labY.width
           + editY.width + 25 // 设置按钮的横坐标
        y: 5 // 设置纵坐标
        text: "修改" // 按钮文本
        width: 150
        height: 50
        // 信号槽连接
        onClicked: {
            console.log("btnEdit onClicked")
            let editedX = parseFloat(editX.text)
            let editedY = parseFloat(editY.text)
            console.log(editedX, editedY)
            if (editedX === NaN || editedY === NaN) {
                return
            }
            handler.updatePoint(editedX, editedY)
            console.log(editX.text, editY.text)
            scatter.moveTo(editedX, editedY)
        }
        font.pixelSize: 25
    }
    Button {
        id: btnDelete
        x: openFileButton.width + editX.width + labX.width + labY.width
           + editY.width + btnEdit.width + 25 // 设置按钮的横坐标
        y: 5 // 设置纵坐标
        text: "删除" // 按钮文本
        width: 150
        height: 50
        // 信号槽连接
        onClicked: {
            console.log("btnDelete onClicked")
            handler.removePoint()
            scatter.removePoint()
        }
        font.pixelSize: 25
    }

    Rectangle {
        x: 0
        y: openFileButton.height + 5
        width: parent.width
        height: parent.height - openFileButton.height - 5

        ChartView {

            title: "Line Chart"
            id: chartView
            anchors.fill: parent
            antialiasing: true
            ValueAxis {
                id: valueAxisX
                min: 0 // x轴最小值
                max: 10 // x轴最大值
            }
            ValueAxis {
                id: valueAxisY
                min: 0 // y轴最小值
                max: 20 // y轴最大值
            }
            LineSeries {
                id: lineSeries1
                name: "Line1"
                axisX: valueAxisX
                axisY: valueAxisY
                pointsVisible: true
                onHovered: {
                    let len = Math.abs(point.x - lineSeries1.at(
                                           0).x) + Math.abs(
                            point.y - lineSeries1.at(0).y)
                    let selectedIdx = 0
                    for (var i = 1; i < lineSeries1.count; i++) {
                        if (len > Math.abs(point.x - lineSeries1.at(
                                               i).x) + Math.abs(
                                    point.y - lineSeries1.at(i).y)) {
                            len = Math.abs(point.x - lineSeries1.at(
                                               i).x) + Math.abs(
                                        point.y - lineSeries1.at(i).y)
                            selectedIdx = i
                        }
                    }
                    if (scatter.count > 0) {
                        if (scatter.at(0).x === lineSeries1.at(selectedIdx).x
                                && scatter.y === lineSeries1.at(
                                    selectedIdx).y) {
                            return
                        } else {
                            scatter.replace(scatter.at(0).x, scatter.at(0).y,
                                            lineSeries1.at(selectedIdx).x,
                                            lineSeries1.at(selectedIdx).y)
                            handler.selectedLine = 1
                            handler.selectedPoint = selectedIdx
                            return
                        }
                    }
                    handler.selectedLine = 1
                    handler.selectedPoint = selectedIdx
                    scatter.append(lineSeries1.at(selectedIdx).x,
                                   lineSeries1.at(selectedIdx).y)
                }
                function updateList() {
                    console.log("updatelist1")
                    lineSeries1.clear()
                    let minnX = 999, maxnX = -1
                    let minnY = 999, maxnY = -1
                    // console.log(handler.x1)
                    for (var i = 0; i < handler.x1.length; i++) {
                        lineSeries1.append(handler.x1[i], handler.y1[i])
                        if (minnX > handler.x1[i]) {
                            minnX = handler.x1[i]
                        }
                        if (minnY > handler.y1[i]) {
                            minnY = handler.y1[i]
                        }
                        if (maxnX < handler.x1[i]) {
                            maxnX = handler.x1[i]
                        }
                        if (maxnY < handler.y1[i]) {
                            maxnY = handler.y1[i]
                        }
                    }
                    valueAxisX.max = maxnX
                    valueAxisX.min = minnX
                    valueAxisY.max = maxnY
                    valueAxisY.min = minnY
                    // chartView.update()
                }
            }
            LineSeries {
                id: lineSeries2
                name: "Line2"
                axisX: valueAxisX
                axisY: valueAxisY
                pointsVisible: true
                onHovered: {
                    let len = Math.abs(point.x - lineSeries2.at(
                                           0).x) + Math.abs(
                            point.y - lineSeries2.at(0).y)
                    let selectedIdx = 0
                    for (var i = 1; i < lineSeries2.count; i++) {
                        if (len > Math.abs(point.x - lineSeries2.at(
                                               i).x) + Math.abs(
                                    point.y - lineSeries2.at(i).y)) {
                            len = Math.abs(point.x - lineSeries2.at(
                                               i).x) + Math.abs(
                                        point.y - lineSeries2.at(i).y)
                            selectedIdx = i
                        }
                    }
                    if (scatter.count > 0) {
                        if (scatter.at(0).x === lineSeries2.at(selectedIdx).x
                                && scatter.y === lineSeries2.at(
                                    selectedIdx).y) {
                            return
                        } else {
                            scatter.replace(scatter.at(0).x, scatter.at(0).y,
                                            lineSeries2.at(selectedIdx).x,
                                            lineSeries2.at(selectedIdx).y)
                            handler.selectedLine = 2
                            handler.selectedPoint = selectedIdx
                            return
                        }
                    }
                    handler.selectedLine = 2
                    handler.selectedPoint = selectedIdx
                    scatter.append(lineSeries2.at(selectedIdx).x,
                                   lineSeries2.at(selectedIdx).y)
                }
                function updateList() {
                    console.log("updatelist2")
                    lineSeries2.clear()
                    // console.log(handler.x1)
                    // console.log(typeof (handler.x2))
                    let minnX = 999, maxnX = -1
                    let minnY = 999, maxnY = -1
                    for (var i = 0; i < handler.x2.length; i++) {
                        // console.log(handler.x2[i], handler.y2[i])
                        lineSeries2.append(handler.x2[i], handler.y2[i])
                        if (minnX > handler.x2[i]) {
                            minnX = handler.x2[i]
                        }
                        if (minnY > handler.y2[i]) {
                            minnY = handler.y2[i]
                        }
                        if (maxnX < handler.x2[i]) {
                            maxnX = handler.x2[i]
                        }
                        if (maxnY < handler.y2[i]) {
                            maxnY = handler.y2[i]
                        }
                    }

                    if (maxnX > valueAxisX.max) {
                        valueAxisX.max = maxnX
                    }

                    if (minnX < valueAxisX.min) {
                        valueAxisX.min = minnX
                    }
                    if (maxnY > valueAxisY.max) {
                        valueAxisY.max = maxnY
                    }
                    if (minnY < valueAxisY.min) {
                        valueAxisY.min = minnY
                    }
                    let crossX = valueAxisX.max - valueAxisX.min
                    let crossY = valueAxisY.max - valueAxisY.min
                    valueAxisX.max += crossX * 0.01
                    valueAxisX.min -= crossX * 0.01
                    valueAxisY.max += crossY * 0.1
                    valueAxisY.min -= crossY * 0.1
                    // chartView.update()
                }
            }
            ScatterSeries {
                id: scatter
                function removePoint() {
                    handler.selectedLine = -1
                    handler.selectedPoint = -1
                    editX.inputUpdate()
                    editY.inputUpdate()
                    scatter.clear()
                }

                function moveTo(newX, newY) {
                    if (scatter.count > 0) {
                        if (scatter.at(0).x === newX && scatter.at(
                                    0).y === newY) {
                            return
                        } else {
                            scatter.replace(scatter.at(0).x, scatter.at(0).y,
                                            newX, newY)
                            return
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "请选择一个文件"
        onAccepted: {
            handler.readCSV(fileDialog.currentFile)
        }
        onRejected: {
            console.log("取消")
        }
    }
    Connections {
        target: handler
        function onListUpdate() {
            lineSeries1.updateList()
            lineSeries2.updateList()
        }
        function onInputUpdate() {
            console.log("onEditUpdate")
            editX.inputUpdate()
            editY.inputUpdate()
        }
        function onRemoveSelectedPoint() {
            console.log("onRemoveSelectedPoint")
            scatter.removePoint()
        }
    }
}
