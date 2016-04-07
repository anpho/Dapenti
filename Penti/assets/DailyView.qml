import bb.cascades 1.4
import bb.system 1.2
import lib.anpho 1.0
Page {
    property NavigationPane nav
    property string titleString
    property string uri
    onUriChanged: {
        if (uri.length > 0) {
            startLoad()
        }
    }
    function startLoad() {
        co.ajax("GET", uri, [], function(b, d) {
                if (b) {
                    processContent(d);
                } else {
                    ssd.body = qsTr("Error description is : ") + d;
                    ssd.show();
                }
            }, [], false)
    }
    function processContent(htmlsource) {
        var removeScripts = /<script[^>]*?>.*?<\/script>/ig;
        var removeTags = /<(?!img|br).*?>/ig;
        var alteredContent = htmlsource.replace(removeScripts, "");
        alteredContent = alteredContent.replace(removeTags, "");
        var paragraphs = alteredContent.split(/【\d+】/);
        paragraphs.shift();
        paragraphs.pop();
        adm.append(paragraphs)
    }
    id: pageroot
    attachedObjects: [
        Common {
            id: co
        },
        SystemDialog {
            title: "Error"
            confirmButton.label: qsTr("Reload")
            cancelButton.label: qsTr("Cancel")
            customButton.enabled: false
            confirmButton.enabled: true
            cancelButton.enabled: true
            id: ssd
            onFinished: {
                console.log(value);
                if (value == 2) {
                    startLoad()
                } else {
                    nav.pop();
                }
            }
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Compact
    ListView {
        dataModel: ArrayDataModel {
            id: adm
        }
        function requestImageView(path) {
            _app.viewimage(path)
        }
        listItemComponents: [
            ListItemComponent {
                type: ""
                Container {
                    id: rootcontainer
                    Container {
                        id: xContent
                        topPadding: 20.0
                        horizontalAlignment: HorizontalAlignment.Fill
                    }
                    property string para: ListItemData
                    function trimEx(str) {
                        return str.replace(/\s{2,}/ig, "\n");
                    }
                    onParaChanged: {
                        var p = trimEx(para);
                        var arrayp = p.split("\n");
                        xContent.removeAll();
                        var divider = div.createObject(rootcontainer)
                        xContent.add(divider)
                        var ttl = titletext.createObject(rootcontainer)
                        ttl.text = arrayp[0];
                        xContent.add(ttl);

                        for (var i = 1; i < arrayp.length; i ++) {
                            if (arrayp[i].indexOf("<img") > -1) {
                                appendImage(arrayp[i])
                            } else {
                                appendText(arrayp[i])
                            }
                        }
                    }
                    function appendImage(str) {
                        var tempstr = str.split(/\s+/);
                        var imgurl;
                        for (var i = 1; i < tempstr.length; i ++) {
                            if (tempstr[i].indexOf("src") > -1) {
                                imgurl = tempstr[i].split(/["|']/)[1]
                                break;
                            }
                        }
                        console.log(imgurl)
                        if (imgurl.length > 0) {
                            var imagex = webimg.createObject(rootcontainer);
                            imagex.url = imgurl;
                            xContent.add(imagex);
                        }
                    }
                    function appendText(str) {
                        if (str.trim() == "") {
                            return;
                        }
                        var l = lbl.createObject(rootcontainer)
                        l.text = str;
                        xContent.add(l);
                    }
                    attachedObjects: [
                        ComponentDefinition {
                            id: webimg
                            WebImageView {
                                scalingMethod: ScalingMethod.AspectFit
                                horizontalAlignment: HorizontalAlignment.Fill
                                topMargin: 20.0
                                bottomMargin: 20.0
                                id: wb
                                gestureHandlers: TapHandler {
                                    onTapped: {
                                        rootcontainer.ListItem.view.requestImageView(wb.getCachedPath())
                                    }
                                }
                            }
                        },
                        ComponentDefinition {
                            id: lbl
                            Label {
                                textStyle.fontSize: FontSize.Large
                                textStyle.fontWeight: FontWeight.W100
                                multiline: true
                                horizontalAlignment: HorizontalAlignment.Fill
                                textFit.mode: LabelTextFitMode.Standard
                                textStyle.textAlign: TextAlign.Left
                                textFormat: TextFormat.Html
                                topMargin: 20.0
                                bottomMargin: 20.0
                            }
                        },
                        ComponentDefinition {
                            id: titletext
                            Label {
                                textStyle.fontSize: FontSize.XLarge
                                textStyle.fontWeight: FontWeight.W100
                                horizontalAlignment: HorizontalAlignment.Fill
                                textStyle.textAlign: TextAlign.Left
                                multiline: true
                                textFormat: TextFormat.Html
                                topMargin: 20.0
                                bottomMargin: 10.0
                                textStyle.color: ui.palette.primary
                            }
                        },
                        ComponentDefinition {
                            id: div
                            Divider {

                            }
                        }
                    ]

                    horizontalAlignment: HorizontalAlignment.Fill
                }
            }
        ]
        leftPadding: 20.0
        rightPadding: 20.0
        topPadding: 20.0
        bottomPadding: 50.0
        horizontalAlignment: HorizontalAlignment.Fill
        scrollRole: ScrollRole.Main
    }
}
