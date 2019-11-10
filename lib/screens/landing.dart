import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mechaniks_mechanic/data/tickets_repository.dart';
import 'package:mechaniks_mechanic/data/user_repository.dart';
import 'package:mechaniks_mechanic/models/ticket.dart';
import 'package:mechaniks_mechanic/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TicketsPage();
  }
}

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 0.9;
    UserRepository userRepository = Provider.of<UserRepository>(context);
    List<Ticket> tickets = Provider.of<TicketsRepository>(context).tickets;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tickets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (tickets.length == 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/images/empty.svg',
                              width: size.width * 0.75,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'No ticket created yet.',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, i) {
                        return TicketItem(
                          ticket: tickets[i],
                        );
                      },
                      itemCount: tickets.length,
                    ),
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: RaisedButton(
                color: Colors.white,
                elevation: 0,
                onPressed: userRepository.signOut,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: getPrimaryColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketItem extends StatefulWidget {
  final Ticket ticket;

  const TicketItem({Key key, this.ticket}) : super(key: key);

  @override
  _TicketItemState createState() => _TicketItemState();
}

class _TicketItemState extends State<TicketItem> {
  String address;

  @override
  void initState() {
    super.initState();
    address = "";
    getAddress();
  }

  Future<void> getAddress() async {
    String add = await getAddressFromGeoFirePoint(widget.ticket.userlocation);
    setState(() {
      address = add;
    });
  }

  Future<void> call() async {
    String url = "tel:" + widget.ticket.userphone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Some error occurred while calling');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.ticket.username != null &&
                widget.ticket.username.length > 0)
              Text(
                'Client name : ' + widget.ticket.username,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (widget.ticket.userphone != null &&
                widget.ticket.userphone.length > 0)
              Text(
                'Client phone : ' + widget.ticket.userphone,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Text(
              'Client Address : ' + address,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            getTicketStatusWidget(widget.ticket),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  onPressed: () async {
                    await call();
                  },
                  child: Text(
                    "Call",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 0.5,
                  height: 25,
                  color: Colors.grey.shade500,
                ),
                MaterialButton(
                  onPressed: () async {
                    Provider.of<TicketsRepository>(context)
                        .acceptTicket(widget.ticket);
                  },
                  child: Text(
                    "Accept",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 0.5,
                  height: 25,
                  color: Colors.grey.shade500,
                ),
                MaterialButton(
                  onPressed: () async {
                    Provider.of<TicketsRepository>(context)
                        .rejectTicket(widget.ticket);
                  },
                  child: Text(
                    "Reject",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
