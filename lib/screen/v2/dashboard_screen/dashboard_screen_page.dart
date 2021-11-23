import 'package:carkee/components/bottom_ads.dart';
import 'package:carkee/components/empty_view_refresh.dart';
import 'package:carkee/components/load_image_component.dart';
import 'package:carkee/components/search_bar_phung.dart';
import 'package:carkee/config/colors.dart';
import 'package:carkee/config/singleton.dart';
import 'package:carkee/config/styles.dart';
import 'package:carkee/screen/news_details_web.dart';
import 'package:extended_text/extended_text.dart';

/// Generated by Flutter GetX Starter on 2021-08-01 19:57
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'dashboard_screen_logic.dart';

class DashboardScreenPage extends StatefulWidget {
  @override
  _DashboardScreenPageState createState() => _DashboardScreenPageState();
}

class _DashboardScreenPageState extends State<DashboardScreenPage> {
  final DashboardScreenLogic logic = Get.put(DashboardScreenLogic());

  @override
  void dispose() {
    Get.delete<DashboardScreenLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Home", style: Styles.mclub_Tilte),
          elevation: 1,
          leading: IconButton(
            padding: EdgeInsets.only(left: 10),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
            iconSize: 30,
            color: Colors.black,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (Session.shared.isLogedin()) {
                  Session.shared.goProfileTab();
                } else {
                  print("no login");
                }
              },
              child: Session.shared.isLogedin() ? Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    backgroundImage: NetworkImage(Session.shared
                        .getProfileController()
                        .getProfileImage())),
              ): SizedBox(),
            )
          ]
        ),
        body: Obx(
            () => (logic.isDoneLoadAPI.value) ? buildBody2() : loadingView()));
  }

  Widget buildBody2() {
    return LazyLoadScrollView(
      isLoading: logic.isLoading,
      scrollOffset: 200, //0 will disable
      onEndOfPage: () {
        logic.loadMore();
      },
      child: RefreshIndicator(
          onRefresh: logic.refresh,
          child: Column(
            children: [
              Expanded(child: getBody()),
              if (Session.shared.getProfileController().getIsFreeMember() &&
                  logic.modelBottomAdsResult.value.data != null)
                BottomAds(
                  modelBottomAdsResult: logic.modelBottomAdsResult.value,
                ),
            ],
          )),
    );
  }

  Widget loadingView() {
    print("here getNodyNoRecord getNodyNoRecord getNodyNoRecord !");
    return EmptyViewCustom(
      errorString: logic.errorString.value,
      refreshData: logic.refresh,
    );
  }

  getStatusAccount(){
    return Obx(() {
      return Session.shared
          .getProfileController()
          .userProfile
          .value
          .status !=
          '3'
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Html(
            data: Session.shared
                .getProfileController()
                .userProfile
                .value
                .dashboardMessage ??
                ""),
      )
          : SizedBox();
    });
  }

  getBody() {
    return ListView(
      children: [
        getStatusAccount(),
        getSearchbar(),
        getTitleString(),
        getListNews(),
      ],
    );
  }
  getTitleString(){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Config.kDefaultPadding,
          vertical: Config.kDefaultPadding),
      child: Text(
        'What’s Happening?',
        style: Styles.mclub_smallTilteBold,
      ),
    );
  }

  getListNews() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: logic.listData.length,
        itemBuilder: (BuildContext context, int itemIndex) {
          return GestureDetector(
            onTap: () {
              var itemTapped = logic.listData[itemIndex];
              print('itemTapped newsId ${itemTapped.newsId}');

              //check if ads.
              logic.listData[itemIndex].type == "ads"
                  ? Session.shared.openWebView(
                      title: "Ads", url: logic.listData[itemIndex].url ?? "")
                  : Get.to(
                      () => DetailsNewsWeb(
                          modelNews: itemTapped,
                          newsType: NewsType.News,
                          title: "News"),
                    );
            },
            child: buildItemList2(itemIndex),
          );
        });
  }

  getSearchbar() {
    return SearchBarPhung(startSearching: (stringValue) {
      logic.searchTextString = stringValue;
      logic.callAPIGetList(); //temp search not working.. need API! page , keyword..v.v
    }, reload: () {
      logic.refresh();
    });
  }

  buildItemList2(int itemIndex) {
    return Container(
      // color: Colors.green,
      // height: 400,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            // color: Colors.yellow,
            // height: 800,
            // width: 800,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                //BOX
                Container(
                  margin: EdgeInsets.only(
                      bottom:
                          100), //khung xanh lá cách 1 doan trên 50., 50 cũng là 1/2 của các box cần dịch.. nên có thể gọi dây cũng la 1 cách
                  // color: Colors.green,
                  child: LoadImageFromUrl(logic.listData[itemIndex].image),
                ),
                //check if is ads!
                logic.listData[itemIndex].title == ""
                    ? SizedBox()
                    : Container(
                        height: 100,
                        width: Get.width - 40,
                        decoration: BoxDecoration(
                            //thêm bóng
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0,
                                      1), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                                  blurRadius: 5,
                                  color: Colors.black26)
                            ],
                            //màu nền của View
                            color: Colors.white,
                            //độ tròn cong
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(bottom: 50),
                        // color: Colors.red,
                        child: Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: Config.kDefaultPadding * 2,
                                        left: Config.kDefaultPadding * 2,
                                        right: Config.kDefaultPadding * 2,
                                        bottom: Config.kDefaultPadding),
                                    child: Text(logic.listData[itemIndex].title,
                                        maxLines: 1,
                                        style: Styles.mclub_smallTilteBold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: Config.kDefaultPadding * 2,
                                        right: Config.kDefaultPadding * 2,
                                        bottom: Config.kDefaultPadding * 2),
                                    child: ExtendedText(
                                      logic.listData[itemIndex].summary,
                                      maxLines: 2,
                                      style: Styles.mclub_smallText,
                                      // overflow: TextOverflow.ellipsis,
                                      overflowWidget: TextOverflowWidget(
                                        maxHeight: 40,
                                        // maxHeight: double.infinity,
                                        //align: TextOverflowAlign.right,
                                        //fixedOffset: Offset.zero,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text('\u2026 '),
                                            Text(
                                              "See more",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Config.secondColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: IconButton(
                                icon: Icon(Icons.chevron_right,
                                    color: Config.secondColor, size: 30),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
