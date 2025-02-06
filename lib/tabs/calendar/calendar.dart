import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/container_cancelled.dart';
import 'package:health_app/widgets/container_complete_doctor.dart';
import 'package:health_app/widgets/container_upcomming.dart';

class Calendar extends StatefulWidget {
  static const String id = '/calendar';

  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final pationToken = BlocProvider.of<AuthCubit>(context).user!.token!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Appointment'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.green,
          labelColor: AppTheme.white,
          unselectedLabelColor: AppTheme.green,
          tabs: [
            Tab(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? AppTheme.green : AppTheme.gray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Complete',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _selectedIndex == 0 ? AppTheme.white : AppTheme.green,
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? AppTheme.green : AppTheme.gray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _selectedIndex == 1 ? AppTheme.white : AppTheme.green,
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == 2 ? AppTheme.green : AppTheme.gray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Cancelled',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _selectedIndex == 2 ? AppTheme.white : AppTheme.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemBuilder: (_, index) => ContainerCompleteDoctor(),
            ),
            ListView.builder(
              itemBuilder: (_, index) => ContainerUpcoming(),
            ),
            ListView.builder(
              itemBuilder: (_, index) => ContainerCancelled(),
            ),
          ],
        ),
      ),
    );
  }
}
