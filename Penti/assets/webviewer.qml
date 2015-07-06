import bb.cascades 1.2

Page {
    property bool darkmode: _app.getValue("darkmode", "false") == "true"
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
            ActionBar.placement: ActionBarPlacement.OnBar
        },
        ActionItem {
            title: qsTr("Dark mode")
            imageSource: darkmode ? "asset:///icon/ic_disable.png" : "asset:///icon/ic_enable.png"
            onTriggered: {
                if (darkmode) {
                    webv.settings.userStyleSheetLocation = "blank.css"
                } else {
                    webv.settings.userStyleSheetLocation = "dark.css"
                }
                darkmode = ! darkmode
                _app.setValue("darkmode", darkmode);
            }
            ActionBar.placement: ActionBarPlacement.OnBar
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    Container {
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill

        background: Color.Black
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            scrollRole: ScrollRole.Main
            WebView {
                id: webv
                horizontalAlignment: HorizontalAlignment.Fill
                preferredHeight: Infinity
                settings.userStyleSheetLocation: darkmode ? "dark.css" : "blank.css"
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
                settings.activeTextEnabled: false

            }
        }
    }
}