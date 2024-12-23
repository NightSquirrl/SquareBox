import HomePage from './HomePage'
import LoginPage from './LoginPage'
import dataPreferences from "@ohos.data.preferences"

@Entry
@Component
struct Index {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()
  store:dataPreferences.Preferences | null = null

  async  aboutToAppear() {
    this.store = await dataPreferences.getPreferences(getContext(this),'squarebox')
    // this.store.put('x','xx')
    // this.store.get('x')
    // this.store.get('x')
  }

  @Builder
  PagesMap(name: string) {
    if (name == 'LoginPage') {
      LoginPage()
    } else if (name == 'HomePage') {
      HomePage()
    }
  }

  build() {
    Navigation(this.pageStack) {
      Text('这是一个引导界面')
      Button('Push DialogPage')
        .margin(20)
        .width('80%')
        .onClick(() => {
          this.pageStack.replacePathByName("LoginPage", "");
        })
    }
    .onAppear(() => {
      this.pageStack.replacePathByName("HomePage", "")

      this.pageStack.setInterception({
        willShow: (from: NavDestinationContext | "navBar", to: NavDestinationContext | "navBar",
          operation: NavigationOperation, animated: boolean) => {
          console.log(JSON.stringify(to))
          if(to === "navBar") {
            this.pageStack.replacePathByName("LoginPage", "");
          }
          // 将跳转到PageTwo的路由重定向到PageOne
          // if (target.pathInfo.name === 'PageTwo') {
          //   target.pathStack.pop();
          //   target.pathStack.pushPathByName('PageOne', null);
          // }
        }
      })
    })
    .hideNavBar(false)
    .mode(NavigationMode.Auto)
    .navDestination(this.PagesMap)
  }
}