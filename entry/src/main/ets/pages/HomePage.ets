@Component
export default struct HomePage {
  @State currentIndex: number = 0

  @Builder tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column(){
            Text('我的内容')
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.tabBuilder('我的', 0, $r('app.media.tools_select'),$r('app.media.tools')))

        TabContent() {
          Column(){
            Text('我的瞎想内容')
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.tabBuilder('个人中心', 0, $r('app.media.individual_center'),$r('app.media.individual_center_select')))

        // TabContent() {
        // }.tabBar(this.tabBuilder('发现', 1))
        //
        // TabContent() {
        // }.tabBar(this.tabBuilder('推荐', 2))
        //
        // TabContent() {
        // }.tabBar(this.tabBuilder('我的', 3))
      }
      .animationDuration(1)
      .onChange((index: number) => {
        this.currentIndex = index
      })

    }.hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}