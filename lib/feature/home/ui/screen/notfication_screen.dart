import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_track/core/theme/color.dart';
import 'package:habit_track/core/theme/style.dart';
import 'package:habit_track/feature/home/cubit/notification_cubit/cubit/notfication_cubit.dart';
import 'package:habit_track/feature/home/data/model/notification_model.dart';

class NotifcationScreen extends StatelessWidget {
  const NotifcationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotficationCubit()..getNotfication(),
      child: Container(
        color: AppColor.primeColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white.withOpacity(.988),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Notfication",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<NotficationCubit, NotficationState>(
                    builder: (context, state) {
                      if (state is NotficationSuccses) {
                        return Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: NotficationWidget(
                                    notfData: state.notficationList[index]),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemCount: state.notficationList.length,
                          ),
                        );
                      } else if (state is NotficationFail) {
                        return Center(
                            child: Text(
                          state.errorMassage,
                          style: const TextStyle(fontSize: 22),
                        ));
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotficationWidget extends StatelessWidget {
  const NotficationWidget({super.key, required this.notfData});
  final NotificationModel notfData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Shadow color with opacity
            spreadRadius: 2, // How much the shadow spreads
            blurRadius: 1, // The blur radius of the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notfData.text!,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Text(
              notfData.date!,
              style: TextAppStyle.subTittel,
            ),
          )
        ],
      ),
    );
  }
}
