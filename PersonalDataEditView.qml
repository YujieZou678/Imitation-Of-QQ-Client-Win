/*
function: 个人信息编辑视图。
author: zouyujie
date: 2024.4.19
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Window {

    id: self
    width: Screen.width/1707*500
    height: Screen.height/1067*300
    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {  //关闭栏
            Layout.fillWidth: true
            Layout.preferredHeight: Screen.height/1067*35
            color: "lightblue"

            RowLayout {
                anchors.fill: parent
                spacing: 0

                DragHandler {  //跟随移动
                    grabPermissions: PointerHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { self.startSystemMove() }
                }

                Item {
                    Layout.preferredWidth: Screen.width/1707*18
                }
                Item {
                    height: Screen.height/1067*35
                    width: Screen.width/1707*40
                    Image {
                        anchors.fill: parent
                        source: "qrc:/image/QQ-01.png"
                        fillMode: Image.PreserveAspectFit
                        scale: 1.5
                        opacity: 0.8
                    }
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Item{
                    height: Screen.height/1067*35
                    width: Screen.width/1707*40
                    MyToolButton {
                        iconSource: "qrc:/image/最小化.png"
                        icon.color: "white"
                        onClicked: {
                            self.showMinimized()
                        }
                    }
                }
                Item {
                    height: Screen.height/1067*35
                    width: Screen.width/1707*40
                    MyToolButton {
                        iconSource: "qrc:/image/关闭.png"
                        icon.color: "white"
                        onClicked: {
                            self.close()
                        }
                    }
                }
            }
        }

        Rectangle {  //基础信息
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*15
                }
                Item {  //基础信息
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {  //基础信息
                            Layout.fillWidth: true
                            Layout.preferredHeight: Screen.height/1067*40
                            Text {
                                text: "基础信息"
                                font {
                                    family: mFONT_FAMILY
                                    pointSize: 12
                                    bold: true
                                }
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Item {  //线
                            Layout.fillWidth: true
                            Layout.preferredHeight: Screen.height/1067*10
                            MenuSeparator { width: parent.width; padding: 0 }
                        }
                        Item {  //昵称 性别
                            Layout.fillWidth: true
                            Layout.preferredHeight: Screen.height/1067*50

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //昵称
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.18
                                    Text {
                                        text: "昵        称"
                                        font {
                                            family: mFONT_FAMILY
                                            pointSize: 12
                                        }
                                        color: "gray"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //输入框
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.32
                                    TextField {
                                        id: nickName
                                        width: parent.width
                                        height: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                        font {
                                            family: window.mFONT_FAMILY
                                            pixelSize: 15
                                        }
                                        text: main_NickName
                                    }
                                }
                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.05
                                }
                                Item {  //性别
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.18
                                    Text {
                                        text: "性        别"
                                        font {
                                            family: mFONT_FAMILY
                                            pointSize: 12
                                        }
                                        color: "gray"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //输入框
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.27
                                    ComboBox {
                                        id: sex
                                        width: parent.width
                                        height: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                        model: ["男", "女"]
                                        currentIndex: main_Sex==="男"? 0:1
                                    }
                                }
                            }
                        }
                        Item {  //属相 血型
                            Layout.fillWidth: true
                            Layout.preferredHeight: Screen.height/1067*50

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //属相
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.18
                                    Text {
                                        text: "属        相"
                                        font {
                                            family: mFONT_FAMILY
                                            pointSize: 12
                                        }
                                        color: "gray"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //输入框
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.32
                                    ComboBox {
                                        id: zodiaSign
                                        width: parent.width
                                        height: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                        model: ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
                                        currentIndex: {
                                            switch (main_ZodiacSign) {
                                            case "鼠": return 0;
                                            case "牛": return 1;
                                            case "虎": return 2;
                                            case "兔": return 3;
                                            case "龙": return 4;
                                            case "蛇": return 5;
                                            case "马": return 6;
                                            case "羊": return 7;
                                            case "猴": return 8;
                                            case "鸡": return 9;
                                            case "狗": return 10;
                                            case "猪": return 11;
                                            }
                                        }  //end switch
                                    }
                                }
                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.05
                                }
                                Item {  //血型
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.18
                                    Text {
                                        text: "血        型"
                                        font {
                                            family: mFONT_FAMILY
                                            pointSize: 12
                                        }
                                        color: "gray"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //输入框
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.27
                                    ComboBox {
                                        id: bloodGroup
                                        width: parent.width
                                        height: parent.height*0.7
                                        anchors.verticalCenter: parent.verticalCenter
                                        model: ["A血型", "B血型", "O血型", "其他血型"]
                                        currentIndex: {
                                            switch (main_BloodGroup) {
                                            case "A血型": return 0;
                                            case "B血型": return 1;
                                            case "O血型": return 2;
                                            case "其他血型": return 3;
                                            }
                                        }  //end switch
                                    }
                                }
                            }
                        }
                        Item {  //签名
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {  //签名
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: parent.width*0.18
                                    Text {
                                        text: "签        名"
                                        font {
                                            family: mFONT_FAMILY
                                            pointSize: 12
                                        }
                                        color: "gray"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                                Item {  //输入框
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    ScrollView {
                                        width: parent.width
                                        height: parent.height*0.8
                                        anchors.verticalCenter: parent.verticalCenter

                                        TextArea {
                                            id: personalSignature
                                            wrapMode: TextEdit.Wrap
                                            background: Rectangle {
                                                border.color: "gray"
                                            }
                                            font {
                                                family: mFONT_FAMILY
                                                pointSize: 12
                                            }
                                            text: main_PersonalSignature
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*15
                }
            }
        }

        Rectangle {  //保存，关闭按钮
            Layout.preferredHeight: Screen.height/1067*40
            Layout.fillWidth: true
            color: "#e2e1e4"
            opacity: 0.5

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Item {  //确定按钮
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*100
                    Item{
                        width: parent.width
                        height: parent.height*0.6
                        anchors.verticalCenter: parent.verticalCenter

                        MyToolButton {
                            text: "保存"
                            font {
                                family: mFONT_FAMILY
                                pointSize: 10
                            }
                            bacColor: "white"
                            clickColor: "#baccd9"
                            onClicked: {
                                /* 主窗口保存所有数据 */
                                if (nickName.text !== "") {
                                    main_NickName = nickName.text        //昵称
                                } else nickName.text = main_NickName
                                main_Sex = sex.currentText               //性别
                                main_ZodiacSign = zodiaSign.currentText  //属相
                                main_BloodGroup = bloodGroup.currentText //血型
                                if (personalSignature.text !== "") {
                                    main_PersonalSignature = personalSignature.text  //个性签名
                                } else personalSignature.text = main_PersonalSignature

                                /* 好友列表刷新（只有自己） */
                                var data = layoutUserView.msgListView.listModel.get(0)
                                data.nickName = main_NickName
                                layoutUserView.msgListView.listModel.set(0, data)

                                /* 服务器保存所有数据 json数组*/
                                var data = {}
                                data.AccountNumber = main_AccountNumber
                                data.NickName = main_NickName
                                data.Sex = main_Sex
                                data.ZodiacSign = main_ZodiacSign
                                data.BloodGroup = main_BloodGroup
                                data.PersonalSignature = main_PersonalSignature

                                toServer_ChangePersonalData(data)  //发送给服务器
                                self.close()
                            }
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*20
                }
                Item {  //取消按钮
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*100
                    Item{
                        width: parent.width
                        height: parent.height*0.6
                        anchors.verticalCenter: parent.verticalCenter

                        MyToolButton {
                            text: "关闭"
                            font {
                                family: mFONT_FAMILY
                                pointSize: 10
                            }
                            bacColor: "white"
                            clickColor: "#baccd9"
                            onClicked: {
                                /* 数据还原 */
                                nickName.text = main_NickName             //昵称
                                sex.currentIndex = main_Sex==="男"? 0:1   //性别
                                switch (main_ZodiacSign) {                //属相
                                case "鼠":
                                    zodiaSign.currentIndex = 0
                                    break
                                case "牛":
                                    zodiaSign.currentIndex = 1
                                    break
                                case "虎":
                                    zodiaSign.currentIndex = 2
                                    break
                                case "兔":
                                    zodiaSign.currentIndex = 3
                                    break
                                case "龙":
                                    zodiaSign.currentIndex = 4
                                    break
                                case "蛇":
                                    zodiaSign.currentIndex = 5
                                    break
                                case "马":
                                    zodiaSign.currentIndex = 6
                                    break
                                case "羊":
                                    zodiaSign.currentIndex = 7
                                    break
                                case "猴":
                                    zodiaSign.currentIndex = 8
                                    break
                                case "鸡":
                                    zodiaSign.currentIndex = 9
                                    break
                                case "狗":
                                    zodiaSign.currentIndex = 10
                                    break
                                case "猪":
                                    zodiaSign.currentIndex = 11
                                    break
                                }
                                switch (main_BloodGroup) {                //血型
                                case "A血型":
                                    bloodGroup.currentIndex = 0
                                    break
                                case "B血型":
                                    bloodGroup.currentIndex = 1
                                    break
                                case "O血型":
                                    bloodGroup.currentIndex = 2
                                    break
                                case "其他血型":
                                    bloodGroup.currentIndex = 3
                                    break
                                }
                                personalSignature.text = main_PersonalSignature //个性签名

                                self.close()
                            }
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: Screen.width/1707*15
                }
            }
        }  //end 保存，取消按钮
    }
}
