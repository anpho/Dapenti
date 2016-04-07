/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2
import bb.data 1.0
import lib.anpho 1.0
NavigationPane {
    property int columns: parseInt(_app.getValue('col', '1'))
    function reloadcolumns() {
        columns = parseInt(_app.getv('col', '1'))
    }
    onPopTransitionEnded: {
        if (nav.top.setActive) {
            nav.top.setActive();
        }
    }
    onPushTransitionEnded: {
        if (nav.top.setActive) {
            nav.top.setActive();
        }
    }
    id: nav
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            onTriggered: {
                var page = Qt.createComponent("about.qml").createObject(nav);
                nav.push(page)
            }
        }
        settingsAction: SettingsActionItem {
            onTriggered: {
                var page = Qt.createComponent("Settings.qml").createObject(nav);
                page.nav = nav;
                nav.push(page)
            }
        }
        actions: [
            ActionItem {
                title: qsTr("Review")
                imageSource: "asset:///icon/ic_open.png"
                onTriggered: {
                    Qt.openUrlExternally("http://appworld.blackberry.com/webstore/content/59963510")
                }
            },
            ActionItem {
                title: qsTr("Toggle Layout")
                imageSource: "asset:///icon/ic_view_grid.png"
                onTriggered: {
                    if (nav.columns == 1) {
                        nav.columns = 2;
                    } else {
                        nav.columns = 1;
                    }
                    _app.setValue("col", nav.columns)
                }
            }
        ]
    }
    property string state_loading: qsTr("Loading RSS")
    property string state_done: qsTr("RSS Loaded")
    property string state_error: qsTr("RSS load failed")
    Page {
        function setActive() {
            tugualist.scrollRole = ScrollRole.Main;
            tugualist.requestFocus()
        }
        titleBar: TitleBar {
            title: qsTr("Penti News")
            scrollBehavior: TitleBarScrollBehavior.NonSticky
        }

        Container {
            layout: DockLayout {

            }
            ListView {
                id: tugualist
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                dataModel: ArrayDataModel {
                    id: adm
                }
                function requestOpenViewer(uri, titlestr) {
                    var mode = _app.getValue("mode", "0");
                    var page;
                    if (mode == "2") {
                        page = Qt.createComponent("DailyView.qml").createObject(nav);
                    } else {
                        page = Qt.createComponent("webviewer.qml").createObject(nav);
                    }
                    page.nav = nav;
                    page.titleString = titlestr;
                    page.uri = uri;
                    nav.push(page)
                }
                scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
                attachedObjects: [
                    LayoutUpdateHandler {
                        onLayoutFrameChanged: {
                            tugualist.wwidth = layoutFrame.width
                        }
                    }
                ]
                property int wwidth: 50
                listItemComponents: [
                    ListItemComponent {
                        type: ""
                        Container {
                            gestureHandlers: [
                                TapHandler {
                                    onTapped: {
                                        itemroot.ListItem.view.requestOpenViewer(ListItemData.description, itemroot.title_intro)

                                    }
                                }
                            ]
                            id: itemroot
                            horizontalAlignment: HorizontalAlignment.Fill
                            leftPadding: 10.0
                            topPadding: 10.0
                            rightPadding: 10.0
                            bottomPadding: 10.0
                            property string fulltitle: ListItemData.title
                            property int splitindex: ListItemData.title.indexOf(String.fromCharCode(12305)) + 1
                            property string title_intro: ListItemData.title.substring(splitindex)
                            property string readurl: ListItemData.description
                            Header {
                                subtitle: ListItemData.title.substring(0, ListItemData.title.indexOf(String.fromCharCode(12305)) + 1).trim()
                            }
                            Container {
                                layout: DockLayout {

                                }
                                WebImageView {
                                    url: ListItemData.imgurl
                                    scalingMethod: ScalingMethod.AspectFill
                                    loadEffect: ImageViewLoadEffect.FadeZoom
                                    preferredWidth: itemroot.ListItem.view.wwidth
                                    preferredHeight: preferredWidth * 0.618
                                    id: iconOnLeft
                                    horizontalAlignment: HorizontalAlignment.Fill
                                }
                                Container {
                                    background: Color.create("#acffffff")
                                    horizontalAlignment: HorizontalAlignment.Fill
                                    verticalAlignment: VerticalAlignment.Bottom
                                    topPadding: 20.0
                                    leftPadding: 20.0
                                    bottomPadding: 20.0
                                    rightPadding: 20.0
                                    Label {
                                        multiline: false
                                        text: ListItemData.title.substring(ListItemData.title.indexOf(String.fromCharCode(12305)) + 1)
                                        textStyle.color: Color.Black
                                        textStyle.textAlign: TextAlign.Left
                                    }
                                }

                            }
                        }
                    }
                ]
                layout: GridListLayout {
                    columnCount: nav.columns
                    cellAspectRatio: 1.61

                }
                bufferedScrollingEnabled: true
            }
            Container {
                id: stateContainer
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                ActivityIndicator {
                    running: true
                    id: act
                    horizontalAlignment: HorizontalAlignment.Center
                }
                Label {
                    text: state_loading
                    id: statelabel
                    onTextChanged: {
                        if (text != state_loading) {
                            act.running = false;
                        }
                    }
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Center
                }
                Button {
                    text: qsTr("Reload")
                    onClicked: {
                        ds.abort()
                        ds.load()
                    }
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
        onCreationCompleted: {
            ds.load()
        }
        attachedObjects: [
            DataSource {
                id: ds
                source: "http://dapenti.com/blog/tuguaapp.asp"
                remote: true
                type: DataSourceType.Xml
                onDataLoaded: {
                    console.log(JSON.stringify(data))
                    if (! adm.isEmpty()) {
                        adm.clear()
                    }
                    adm.append(data.item)
                    stateContainer.visible = false;
                }
                onError: {
                    console.log(errorMessage);
                    statelabel.text = errorMessage
                }
                query: "rss/channel"
            }
        ]
    }

}