import promptAction from '@ohos.promptAction'
import { AxiosResponse } from "@ohos/axios";
import { loginUrl, registerUrl } from "../api/http-url";
import { http } from "../api/request";


interface ILoginParams {
  "userAccount": string;
  "userPassword": string;
}

@Component
export default struct LoginPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  @State username: string = "";
  @State password: string = "";
  @State confirmPassword: string = "";
  @State isLoading: boolean = false;
  @State loginOrRegister: 0 | 1 = 0; // 0=> 登录 1=> 注册

  aboutToAppear(): void {
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Row() {
          Image($r('app.media.logo')).width("100")
        }

        Row() {
          Text('用户名:').width("25%")
          TextInput({ placeholder: '请输入用户名' }).width("70%").onChange((username) => {
            this.username = username
          })
        }

        Row() {
          Text('密码:').width("25%")
          TextInput({ placeholder: '请输入密码' }).width("70%").type(InputType.Password).onChange((password) => {
            this.password = password
          })
        }

        if (this.loginOrRegister) {
          Row() {
            Text('确认密码:').width("25%")
            TextInput({ placeholder: '请确认密码' }).width("70%").type(InputType.Password).onChange((password) => {
              this.confirmPassword = password
            })
          }

        }

        // 登录注册按钮
        Row({ space: 30 }) {
          // 暂不提供注册,如果用户不存在直接注册
          Button('立即注册')
            .backgroundColor(this.loginOrRegister ? '#237cfa' : '#ffffff')
            .fontColor(this.loginOrRegister ? '#ffffff' : "#000000")
            .onClick(async () => {
              if (!this.loginOrRegister) {
                this.loginOrRegister = 1 // 切换为注册状态
                return
              }
              if (!this.username || !this.password || !this.confirmPassword) {
                return
              }
              // 执行注册请求
              const response: AxiosResponse = await http.post<string, AxiosResponse<ILoginParams>>(registerUrl, {
                userAccount: this.username,
                userPassword: this.password,
                "checkPassword": this.confirmPassword
              })
              console.log(JSON.stringify(response))
              if (response.data?.userAccount === this.username) {
                promptAction.showToast({
                  message: "注册成功"
                })
              }
            })
          Button() {
            Row({ space: 5 }) {
              if (this.isLoading) {
                Progress({ value: 40, total: 100, type: ProgressType.Ring })
                  .width(20)
                  .height(20)
                  .color(Color.White)// 进度条前景色为灰色
                  .backgroundColor('#f5a19b')
                  .style({ strokeWidth: 5 })
              }
              Text('登录').fontColor('#ffffff').fontSize(20)
                .fontColor(this.loginOrRegister ? '#000000' : '#ffffff')
            }
          }
          .padding(10)
          .enabled(!this.isLoading)
          .backgroundColor(this.loginOrRegister ? '#ffffff' : '#237cfa')
          .width("90")
          .onClick(async () => {
            if (this.loginOrRegister) {
              this.loginOrRegister = 0 //切换到注册状态
              return
            }
            this.isLoading = true
            if (!this.password || !this.username) {
              return
            }
            const response: AxiosResponse = await http.post<string, AxiosResponse<ILoginParams>>(loginUrl, {
              userAccount: this.username,
              userPassword: this.password
            })
            console.log(JSON.stringify(response))
            if (response.data?.user.userAccount === this.username) {
              promptAction.showToast({
                message: "登录成功"
              })
            }
            this.isLoading = false
          })
        }.padding({ bottom: 100 })
      }
      .padding({ left: 20, right: 20 })
      .height('100%')
      .backgroundImage($r('app.media.login_bg'))
      .backgroundImageSize(ImageSize.Contain)
      .backgroundImagePosition(Alignment.BottomEnd)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}