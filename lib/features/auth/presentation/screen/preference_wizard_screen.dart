import 'package:flutter/material.dart';
import 'package:meal_plan_app/features/auth/presentation/widgets/steps_wizard.dart';

class PreferenceWizardScreen extends StatefulWidget {
  const PreferenceWizardScreen({super.key});

  @override
  State<PreferenceWizardScreen> createState() => _PreferenceWizardScreenState();
}

class _PreferenceWizardScreenState extends State<PreferenceWizardScreen>
  with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final viewRoutes = const <Widget>[
    Center(child: Text('Page 1')),
    Center(child: Text('Page 2')),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: viewRoutes.length,
        itemBuilder: (context, index) {
          return _PreferenceWizardView(
            pageIndex: index,
            totalSteps: viewRoutes.length,
            child: viewRoutes[index],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PreferenceWizardView extends StatelessWidget {
  final Widget? child;
  final int pageIndex;
  final int totalSteps;
  const _PreferenceWizardView({this.child, required this.pageIndex, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StepsWizard(currentStep: pageIndex + 1, totalSteps: totalSteps),
          Expanded(child: child ?? Container()),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (pageIndex > 0) ElevatedButton(
                onPressed: () {},
                child: const Text('Previous'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Next'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
