import bb.cascades 1.2

Page {
    actions: [
        ActionItem {
            title: qsTr("Website")
            onTriggered: {
                Qt.openUrlExternally("http://www.dapenti.com")
            }
            imageSource: "asset:///icon/ic_browser.png"
            ActionBar.placement: ActionBarPlacement.OnBar
        }
    ]
    Container {
        layout: DockLayout {

        }
        Container {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            Label {
                text: qsTr("If you feel uncomfortable when reading these articles")
                horizontalAlignment: HorizontalAlignment.Center
                multiline: true
                textStyle.textAlign: TextAlign.Center
            }
            Label {
                text: qsTr("Please watch CCTV to cure yourself")
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
        Label {
            text: qsTr("This app is licensed by www.dapenti.com")
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XSmall
            textFormat: TextFormat.Auto
        }
    }
}
