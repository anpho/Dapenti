import bb.cascades 1.2

Page {
    property alias uri: webv.url
    titleBar: TitleBar {
        title: webv.title
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    actions: [
        ActionItem {
            title: qsTr("Open in browser")
            onTriggered: {
                Qt.openUrlExternally(uri)
            }
            imageSource: "asset:///icon/ic_open.png"
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    Container {
        ProgressIndicator {
            fromValue: 0
            toValue: 100
            value: webv.loadProgress
            visible: webv.loading
            horizontalAlignment: HorizontalAlignment.Fill
        }
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            WebView {
                id: webv
                horizontalAlignment: HorizontalAlignment.Fill
                preferredHeight: Infinity
                onNavigationRequested: {
                    if (url.toString().trim().length == 0) {
                        return;
                    }
                    if (request.navigationType == WebNavigationType.LinkClicked || request.navigationType == WebNavigationType.OpenWindow) {
                        request.action = WebNavigationRequestAction.Ignore
                        var page = Qt.createComponent("webviewer.qml").createObject(nav);
                        page.uri = request.url;
                        nav.push(page)
                    }
                }
                settings.userAgent: "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
                settings.defaultFontSizeFollowsSystemFontSize: true
                settings.zoomToFitEnabled: true
                settings.activeTextEnabled: true
            }
        }
    }
}
