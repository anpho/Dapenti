import bb.cascades 1.4

Page {
    property NavigationPane nav
    titleBar: TitleBar {
        title: qsTr("Settings")
        dismissAction: ActionItem {
            title: qsTr("Back")
            onTriggered: {
                nav.pop()
            }
        }
    }
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    ScrollView {
        scrollRole: ScrollRole.Main
        Container {
            Header {
                title: qsTr("VISUAL SETTINGS")
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                topPadding: 20.0
                leftPadding: 20.0
                rightPadding: 20.0
                bottomPadding: 20.0

                Label {
                    text: qsTr("Use Dark Theme")
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                }
                ToggleButton {
                    checked: Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark
                    onCheckedChanged: {
                        checked ? _app.setValue("use_dark_theme", "dark") : _app.setValue("use_dark_theme", "bright")
                        try {
                            Application.themeSupport.setVisualStyle(checked ? VisualStyle.Dark : VisualStyle.Bright);
                        } catch (e) {
                        }
                    }
                }
            }
            Container {
                leftPadding: 20.0
                rightPadding: 20.0
                bottomPadding: 20.0
                Label {
                    multiline: true
                    text: qsTr("Turn this on to save battery on OLED screen devices.")
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XSmall
                }
            }
            Header {
                title: qsTr("READER MODE")
            }
            SegmentedControl {
                selectedIndex: parseInt(_app.getValue("mode", "0"))
                onSelectedIndexChanged: {
                    _app.setValue("mode", selectedIndex)
                }
                id: sc
                options: [
                    Option {
                        text: qsTr("WebView")
                    },
                    Option {
                        text: qsTr("Web No AD")
                    },
                    Option {
                        text: qsTr("Pure")
                    }
                ]
            }
            Container {
                leftPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: qsTr("Open issues in standard WebView, with comments , ADs, etc.")
                    multiline: true
                    visible: sc.selectedIndex == 0
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XSmall
                    textFit.mode: LabelTextFitMode.FitToBounds
                }
                Label {
                    text: qsTr("Open issues in disabled javascript WebView, without comments or ADs.")
                    multiline: true
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XSmall
                    visible: sc.selectedIndex == 1
                    textFit.mode: LabelTextFitMode.FitToBounds
                }
                Label {
                    text: qsTr("Open issues in processed native UI, this is the fastest way, but comments / ADs / Videos are all un-supported. (highly experimental)")
                    multiline: true
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.fontSize: FontSize.XSmall
                    visible: sc.selectedIndex == 2
                    textFit.mode: LabelTextFitMode.FitToBounds
                }
            }

        }
    }
}
