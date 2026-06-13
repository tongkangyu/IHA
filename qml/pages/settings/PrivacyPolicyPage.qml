import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: typeof window !== 'undefined' && window.darkMode ? "#0D0D0F" : "#F5F5F7"

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + 120
        clip: true

        ColumnLayout {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            anchors.top: parent.top
            anchors.topMargin: 60
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                Rectangle {
                    width: 32; height: 32; radius: 16
                    color: window.darkMode ? "#2A2A2C" : "#E5E5EA"
                    Text {
                        anchors.centerIn: parent
                        text: "<"
                        font.pixelSize: 16
                        color: window.darkMode ? "#FFFFFF" : "#1A1A1A"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: navigationStack.goBack()
                    }
                }
                Text {
                    text: "隐私政策"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    color: window.darkMode ? "#FFFFFF" : "#1A1A1A"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
                Item { width: 32 }
            }

            Text {
                Layout.fillWidth: true
                Layout.topMargin: 16
                text: "智能健康管理平台隐私政策"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: window.darkMode ? "#FFFFFF" : "#1A1A1A"
            }

            Text {
                Layout.fillWidth: true
                text: "更新日期: 2026年5月29日"
                font.pixelSize: 12
                color: window.darkMode ? "#71717A" : "#8E8E93"
            }

            Text {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                lineHeight: 1.6
                font.pixelSize: 14
                color: window.darkMode ? "#A1A1AA" : "#3C3C43"
                text: "一、信息收集范围\n\n" +
                      "本应用收集以下类型的数据用于提供健康管理服务：\n" +
                      "1. 账户信息：手机号、昵称、性别、生日、身高等基础资料\n" +
                      "2. 健康数据：心率、血压、血氧、体温、步数、睡眠等生理指标\n" +
                      "3. 环境数据：温湿度、CO2、PM2.5、甲醛等室内环境指标\n" +
                      "4. 设备信息：已绑定IoT设备的标识、类型和状态\n\n" +
                      "二、数据使用目的\n\n" +
                      "1. 提供融合健康仪表盘和数据可视化服务\n" +
                      "2. AI健康管家对话与个性化建议生成\n" +
                      "3. 健康趋势分析与异常预警\n" +
                      "4. 在用户授权范围内向家人或医生共享数据\n\n" +
                      "三、数据安全保障\n\n" +
                      "1. 所有数据传输采用HTTPS加密\n" +
                      "2. 密码使用不可逆哈希算法存储\n" +
                      "3. 数据授权遵循最小权限原则\n" +
                      "4. 用户可随时撤销对他人的数据授权\n\n" +
                      "四、AI服务声明\n\n" +
                      "本应用集成AI健康管家功能，基于大语言模型提供健康建议。请注意：\n" +
                      "1. AI建议仅供参考，不构成医疗诊断\n" +
                      "2. 如有健康问题，请咨询专业医生\n" +
                      "3. AI对话内容不会用于训练模型\n\n" +
                      "五、用户权利\n\n" +
                      "1. 查看权：您可以随时查看本应用收集的个人数据\n" +
                      "2. 修改权：您可以随时修改个人资料信息\n" +
                      "3. 删除权：您可以申请删除账户及所有关联数据\n" +
                      "4. 撤销权：您可以随时撤销数据共享授权\n\n" +
                      "六、联系方式\n\n" +
                      "如有隐私相关疑问，请联系：\n" +
                      "华南农业大学 计算机科学与技术24级3班 开发团队"
            }
        }
    }
}
