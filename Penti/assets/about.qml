import bb.cascades 1.2

Page {
    Container {
        layout: DockLayout {

        }
        Container {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            Label {
                text: qsTr("If you feel uncomfortable")
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                text: qsTr("Please watch CCTV to cure yourself")
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
        Label {
            text: qsTr("This app is licensed by dapenti.com")
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XSmall
        }
    }
}
