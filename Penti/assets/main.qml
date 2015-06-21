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
    id: nav
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            onTriggered: {
                var page = Qt.createComponent("about.qml").createObject(nav);
                nav.push(page)
            }
        }
    }
    property string state_loading: qsTr("Loading RSS")
    property string state_done: qsTr("RSS Loaded")
    property string state_error: qsTr("RSS load failed")
    Page {
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
                function requestOpenViewer(uri) {
                    var page = Qt.createComponent("webviewer.qml").createObject(nav);
                    page.uri = uri;
                    nav.push(page)
                }
                scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
                listItemComponents: [
                    ListItemComponent {
                        type: ""
                        Container {
                            gestureHandlers: [
                                TapHandler {
                                    onTapped: {
                                        itemroot.ListItem.view.requestOpenViewer(ListItemData.description)
                                        
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
                                title: ListItemData.title.substring(0, ListItemData.title.indexOf(String.fromCharCode(12305)) + 1).trim()
                            }
                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight

                                }
                                topPadding: 10.0
                                bottomPadding: 10.0
                                WebImageView {
                                    url: ListItemData.imgurl
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 0.38
                                    }
                                    scalingMethod: ScalingMethod.AspectFit
                                    loadEffect: ImageViewLoadEffect.FadeZoom
                                }
                                Label {
                                    multiline: true
                                    text: ListItemData.title.substring(ListItemData.title.indexOf(String.fromCharCode(12305)) + 1)
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 1.0

                                    }
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Left
                                }
                            }
                        }
                    }
                ]
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