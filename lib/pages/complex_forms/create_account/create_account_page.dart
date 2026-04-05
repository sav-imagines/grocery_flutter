import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/components/error_message_component.dart';
import 'package:grocery_flutter/http/user/account_creation_model.dart';
import 'package:grocery_flutter/http/user/account_creation_result.dart';
import 'package:grocery_flutter/http/user/user_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<int>? pfpBytes;
  Image? pfp;

  int scale = 1;
  bool isSending = false;

  final controller = UserController();

  isEmptyValidator(value) {
    return value == null || value.isEmpty ? "Please enter a value" : null;
  }

  final ImagePicker _picker = ImagePicker();
  submitForm() async {
    try {
      if (pfp == null) return;
      setState(() {
        isSending = true;
      });
      var result = await UserController.createAccount(
        AccountCreationModel(
          userName: usernameController.text,
          password: passwordController.text,
          email: emailController.text,
          pfp: pfpBytes!,
        ),
      ).timeout(
        Duration(seconds: 20),
        onTimeout: () => FailureResult(reason: "Timed out after 20 seconds"),
      );
      setState(() {
        isSending = false;
      });
      if (mounted) {
        if (isSuccess(result)) {
          Fluttertoast.showToast(msg: "Created an account successfully");
          Navigator.of(context).pop();
        } else if (result is FailureResult) {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("Error after sending submit:"),
                content: Text(result.reason),
                actions: [
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            msg: result.reason,
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (ctx) => ErrorMessageComponent(
              message: e.toString(),
              title: "Account creation went wrong",
            ),
      );
      Fluttertoast.showToast(msg: "Exception $e");
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  void showSelectImageSource() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 30,
              children: [
                IconButton(
                  onPressed: () => selectImage(context, ImageSource.gallery),
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo,
                        size: 60,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      Text("Gallery"),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => selectImage(context, ImageSource.camera),
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 60,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      Text("Camera"),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void selectImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null && context.mounted) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            // the square around the cropped area
            cropGridColor: Theme.of(context).colorScheme.onSecondaryContainer,
            cropFrameColor: Theme.of(context).colorScheme.onSecondaryContainer,
            cropFrameStrokeWidth: 5,
            // layered over everything outside selected circle
            dimmedLayerColor: const Color.fromRGBO(0, 0, 0, .4),

            // just bg
            // backgroundColor: Color.fromRGBO(205, 127, 153, 1),
            toolbarWidgetColor:
                Theme.of(context).colorScheme.onSecondaryContainer,
            toolbarColor: Theme.of(context).colorScheme.secondaryContainer,
            cropStyle: CropStyle.circle,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: const [CropAspectRatioPreset.square],
            hideBottomControls: true,
          ),
        ],
      );
      if (croppedFile != null) {
        final croppedImageBytes = await croppedFile.readAsBytes();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            pfpBytes = croppedImageBytes.toList();
            pfp = Image.memory(croppedImageBytes);
          });
          Navigator.of(context).pop();
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('New account')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Form(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                pfp == null
                    ? GestureDetector(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 60,
                          minWidth: 60,
                          maxHeight: 200,
                          maxWidth: 200,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.add_photo_alternate, size: 90),
                        ),
                      ),
                      onTap: () => showSelectImageSource(),
                    )
                    : GestureDetector(
                      onTap: () => showSelectImageSource(),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 60,
                          minWidth: 60,
                          maxHeight: 200,
                          maxWidth: 200,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          minRadius: 10_000,
                          foregroundImage: pfp!.image,
                        ),
                      ),
                    ),

                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                  validator: (value) => isEmptyValidator(value),
                ),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  validator: (value) => isEmptyValidator(value),
                ),

                TextFormField(
                  enableSuggestions: false,
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  validator: (value) => isEmptyValidator(value),
                ),

                FilledButton(
                  onPressed: submitForm,
                  child: const Text('Submit'),
                ),

                SizedBox.square(dimension: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
