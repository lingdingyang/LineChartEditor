import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtCharts
import QtQuick.Layouts

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("line chart editor")

    RowLayout {
        width: parent.width
        height: 50
        // anchors.centerIn: parent
        Button {
            id: btnOpenFile
            text: "打开文件"
            width: 150
            height: 50
            onClicked: {
                fileDialog.open()
            }
            font.pixelSize: 25
        }
        Row {
            width: 300
            height: 50
            Label {
                id: labX
                width: 50
                height: 50
                text: "x="
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 25
            }
            TextInput {
                id: editX
                enabled: false
                width: 150
                height: 50
                text: "未选择点"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 25
                function inputUpdate() {
                    if (controller.selectedLine === -1
                            || controller.selectedPoint === -1) {
                        editX.enabled = false
                        editX.text = "未选择点"
                        return
                    }
                    editX.enabled = true
                    if (controller.selectedLine === 1) {
                        editX.text = controller.x1[controller.selectedPoint]
                    } else {
                        editX.text = controller.x2[controller.selectedPoint]
                    }
                }
            }

            Label {
                id: labY
                width: 50
                height: 50
                text: "y="
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 25
            }

            TextInput {
                id: editY
                enabled: false
                width: 150
                height: 50
                text: "未选择点"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 25
                function inputUpdate() {
                    if (controller.selectedLine === -1
                            || controller.selectedPoint === -1) {
                        editY.enabled = false
                        editY.text = "未选择点"
                        return
                    }
                    editY.enabled = true
                    if (controller.selectedLine === 1) {
                        editY.text = controller.y1[controller.selectedPoint]
                    } else {
                        editY.text = controller.y2[controller.selectedPoint]
                    }
                }
            }
        }

        Button {
            id: btnEdit
            text: "修改"
            width: 150
            height: 50
            font.pixelSize: 25
            enabled: false
            onClicked: {
                console.log("btnEdit onClicked")
                let newX = parseFloat(editX.text)
                let newY = parseFloat(editY.text)
                console.log(newX, newY)
                if (newX === NaN || newY === NaN) {
                    return
                }
                controller.updatePoint(newX, newY)
                console.log(editX.text, editY.text)
                scatter.moveTo(newX, newY)
            }
            function updateState() {
                if (controller.selectedLine === -1
                        || controller.selectedPoint === -1) {
                    btnEdit.enabled = false
                    return
                }
                btnEdit.enabled = true
            }
        }
        Button {
            id: btnDelete
            text: "删除"
            width: 150
            height: 50
            font.pixelSize: 25
            enabled: false
            onClicked: {
                console.log("btnDelete onClicked")
                controller.removePoint()
                scatter.removePoint()
            }
            function updateState() {
                if (controller.selectedLine === -1
                        || controller.selectedPoint === -1) {
                    btnDelete.enabled = false
                    return
                }
                btnDelete.enabled = true
            }
        }
    }

    Rectangle {
        x: 0
        y: btnOpenFile.height + 5
        width: parent.width
        height: parent.height - btnOpenFile.height - 5

        ChartView {
            id: chartView
            title: "Line Chart"
            anchors.fill: parent
            antialiasing: true
            ValueAxis {
                id: valueAxisX
                min: 0
                max: 10
            }
            ValueAxis {
                id: valueAxisY
                min: 0
                max: 20
            }
            LineSeries {
                id: lineSeries1
                name: "Line1"
                axisX: valueAxisX
                axisY: valueAxisY
                pointsVisible: true
                // 获取距鼠标最近的点，并高亮显示
                onHovered: {
                    // 计算到每个点的距离并记录最短距离的点的下标
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
                    // 更新高亮显示
                    scatter.moveTo(lineSeries1.at(selectedIdx).x,
                                   lineSeries1.at(selectedIdx).y)
                    controller.selectedLine = 1
                    controller.selectedPoint = selectedIdx
                }
                // 刷新折线图
                function updateList() {
                    console.log("updatelist1")
                    lineSeries1.clear()
                    let minnX = 999, maxnX = -1
                    let minnY = 999, maxnY = -1
                    // console.log(controller.x1)
                    for (var i = 0; i < controller.x1.length; i++) {
                        lineSeries1.append(controller.x1[i], controller.y1[i])
                        if (minnX > controller.x1[i]) {
                            minnX = controller.x1[i]
                        }
                        if (minnY > controller.y1[i]) {
                            minnY = controller.y1[i]
                        }
                        if (maxnX < controller.x1[i]) {
                            maxnX = controller.x1[i]
                        }
                        if (maxnY < controller.y1[i]) {
                            maxnY = controller.y1[i]
                        }
                    }
                    valueAxisX.max = maxnX
                    valueAxisX.min = minnX
                    valueAxisY.max = maxnY
                    valueAxisY.min = minnY
                }
            }
            LineSeries {
                id: lineSeries2
                name: "Line2"
                axisX: valueAxisX
                axisY: valueAxisY
                pointsVisible: true
                // 获取距鼠标最近的点，并高亮显示
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
                    scatter.moveTo(lineSeries2.at(selectedIdx).x,
                                   lineSeries2.at(selectedIdx).y)
                    controller.selectedLine = 2
                    controller.selectedPoint = selectedIdx
                }
                // 刷新折线图
                function updateList() {
                    console.log("updatelist2")
                    lineSeries2.clear()
                    // console.log(controller.x1)
                    // console.log(typeof (controller.x2))
                    let minnX = 999, maxnX = -1
                    let minnY = 999, maxnY = -1
                    for (var i = 0; i < controller.x2.length; i++) {
                        // console.log(controller.x2[i], controller.y2[i])
                        lineSeries2.append(controller.x2[i], controller.y2[i])
                        if (minnX > controller.x2[i]) {
                            minnX = controller.x2[i]
                        }
                        if (minnY > controller.y2[i]) {
                            minnY = controller.y2[i]
                        }
                        if (maxnX < controller.x2[i]) {
                            maxnX = controller.x2[i]
                        }
                        if (maxnY < controller.y2[i]) {
                            maxnY = controller.y2[i]
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
                }
            }
            ScatterSeries {
                id: scatter
                // 去除高亮显示
                function removePoint() {
                    controller.selectedLine = -1
                    controller.selectedPoint = -1
                    editX.inputUpdate()
                    editY.inputUpdate()
                    scatter.clear()
                }
                // 将高亮显示移动到指定位置
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
                    scatter.append(newX, newY)
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "请选择一个文件"
        nameFilters: ["csv files(*.csv)", "任意文件(*)"]
        onAccepted: {
            controller.readCSV(fileDialog.currentFile)
        }
        onRejected: {
            console.log("取消")
        }
    }
    MessageDialog {
        id: msgDialog
        title: "提示"
    }

    Connections {
        target: controller
        function onListUpdate() {
            lineSeries1.updateList()
            lineSeries2.updateList()
        }
        function onInputUpdate() {
            console.log("onEditUpdate")
            editX.inputUpdate()
            editY.inputUpdate()
            btnDelete.updateState()
            btnEdit.updateState()
        }
        function onRemoveSelectedPoint() {
            console.log("onRemoveSelectedPoint")
            scatter.removePoint()
        }
        function onShowDialog(msg) {
            console.log("onShowDialog", msg)
            msgDialog.text = msg
            msgDialog.open()
        }
    }
}
