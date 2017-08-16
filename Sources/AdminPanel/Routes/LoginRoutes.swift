import Vapor
import HTTP
import Routing

public struct LoginRoutes: RouteCollection {

    public typealias Wrapped = Responder

    let drop: Droplet
    let config: Configuration

    public init(droplet: Droplet, config: Configuration) {
        drop = droplet
        self.config = config
    }

    public func build(_ builder: RouteBuilder) {

        let controller = LoginController(droplet: drop)

        // General
        builder.get("/", handler: controller.landing)
        builder.get("/", handler: controller.landing)

        // Login
        builder.get("/login", handler: controller.form)
        builder.post("/login", handler: controller.submit)

        // Reset password
        builder.get("/login/reset", handler: controller.resetPasswordForm)
        builder.post("/login/reset", handler: controller.resetPasswordSubmit)
        builder.get("/login/reset/:token", handler: controller.resetPasswordTokenForm)
        builder.post("/login/reset/change", handler: controller.resetPasswordTokenSubmit)

        // SSO
        if config.ssoProvider != nil {
            builder.get("/login/sso", handler: controller.sso)

            if let ssoCallbackPath: String = config.ssoCallbackPath {
                builder.post(ssoCallbackPath, handler: controller.ssoCallback)
            }
        }
    }
}
