import bb.cascades 1.4

Page {
    id: pageroot
    property NavigationPane nav
    property string titleString
    property int fontsize: _app.getValue("fontsize", webv.settings.defaultFontSize)
    property int mode: parseInt(_app.getValue("mode", "0"))
    onFontsizeChanged: {
        _app.setValue("fontsize", fontsize)
    }
    function setActive() {
        scrollview.scrollRole = ScrollRole.Main;
        scrollview.requestFocus()
    }
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
            ActionBar.placement: ActionBarPlacement.InOverflow
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
            ActionBar.placement: ActionBarPlacement.InOverflow
        },
        ActionItem {
            imageSource: "asset:///icon/ic_decrease.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Fontsize-")
            onTriggered: {
                var newsize = Math.max(12, fontsize - 1)
                webv.evaluateJavaScript("document.body.style.fontSize = '%1px'".arg(newsize))
                fontsize = newsize;
            }
            enabled: webv.isDapenti
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///icon/ic_increase.png"
            title: qsTr("Fontsize+")
            onTriggered: {
                var newsize = Math.min(28, fontsize + 1)
                webv.evaluateJavaScript("document.body.style.fontSize = '%1px'".arg(newsize))
                fontsize = newsize;
            }
            enabled: webv.isDapenti
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///icon/ic_share.png"
            title: qsTr("Share")
            onTriggered: {
                _app.shareURL(webv.url.toString())
            }
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    Container {
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: ui.palette.background
        gestureHandlers: DoubleTapHandler {
            onDoubleTapped: {
                pageroot.actionBarVisibility = (pageroot.actionBarVisibility == ChromeVisibility.Hidden) ? ChromeVisibility.Overlay : ChromeVisibility.Hidden
            }
        }
        ScrollView {
            id: scrollview
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            scrollRole: ScrollRole.Main
            WebView {
                id: webv
                property bool isDapenti: webv.url.toString().indexOf("dapenti.com") > -1
                property bool fontsizeset: false
                visible: loadProgress > 10
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
                onLoadProgressChanged: {
                    if (! fontsizeset && loadProgress > 10) {
                        fontsizeset = true;
                        webv.evaluateJavaScript("document.body.style.fontSize = '%1px'".arg(fontsize))
                    }

                }
                settings.userAgent: "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"
                settings.zoomToFitEnabled: true
                settings.defaultFontSizeFollowsSystemFontSize: true
                settings.textAutosizingEnabled: false
                settings.javaScriptEnabled: mode == 0
            }
        }

    }
}