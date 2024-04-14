A Mobile Application designed to allow the user to test their movements utilizing their cellphone camera in order to test their gait and balance, communicating that data with an artificial intelligence which will make a prediction on the status of Alzheimer's condition in the patient based on that data.

----------------------------------------------------------------------------------
[Amplify]
Install Amplify CLI [https://docs.amplify.aws/swift/start/getting-started/installation/]
- Run "amplify configure"
- Sign in to AWS Account:

Sign-in URL: https://298516394167.signin.aws.amazon.com/console
username: G_5
password: fea4pem3KBU5dvz@kqb

[May need to create a IAM User to generate a Secret Access Key]
Access Key: 
Secret Access Key: 

Run commands:
"npm install -g npm"
    [installs npm]

"npm install -g npx" 
    [installs npx]

"npx install -g @aws-amplify/cli" 
    [Sets up the Amplify CLI]

"npx amplify init"
    [IN root of project folder to initialize and add any local files missing]
    
----------------------------------------------------------------------------------
[Amplify storage]
"amplify pull --appId d2q0l8oj41ms6z --envName staging"

then:
"amplify update storage"

When asked to add a Lambda trigger for S3 bucket (y/n): N

----------------------------------------------------------------------------------
[Quick Pose SDK Key]
Get your free SDK key on [https://dev.quickpose.ai](https://dev.quickpose.ai)
- Register for an account on QuickPose.
- Go to Mobile SDK Keys
- Create SDK Key
- Enter Bundle ID 
- Copy generated SDK Key into var quickPose in CustomCameraController.swift file

----------------------------------------------------------------------------------
[Installing application on physical Mobile Device]
Video Tutorial: https://www.youtube.com/watch?v=Fo1A36RsoCI
- Install Xcode

- Check Xcode and iOS versions are compatible
    [Click Xcode -> About Xcode]
    [Check in iPhone General -> About -> Software Version] 
    
- Add Apple developer account using Apple ID
    [Xcode -> preferences -> Add Apple ID -> enter Apple ID Email and Password]
    
[Sign the App]
- Select Xcode project [AlzDetection]
- Select Signing & Capabilities
- Check box for Automatically manage signing
- Select Team which should appear after registering Apple ID

[Connect Physical Device]
- Connect device through USB
- Unlock iPhone and select Trust Computer
- Select Device to run on Xcode
- Run application and allow Xcode to open the application on the device

----------------------------------------------------------------------------------
[Create AwareMind account]
- Register for an account through the application with Email and Password
- Enter verification code in the email sent through AWS
