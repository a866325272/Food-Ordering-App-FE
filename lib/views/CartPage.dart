import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/Cart.dart';
import 'package:food_ordering_app/widgets/msgToast.dart';
import 'package:velocity_x/velocity_x.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Color(0xff403b58),
        title: "購物車".text.make(),
      ),
      body: CartBody(),
    );
  }
}

class CartBody extends StatefulWidget {
  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CartList().p32().expand(),
        Divider(),
        _CartTotal(),
      ],
    );
  }
}

class _CartList extends StatefulWidget {
  // final Function update;
  // const _CartList({Key key, this.update}) : super(key: key);

  @override
  __CartListState createState() => __CartListState();
}

class __CartListState extends State<_CartList> {
  final CartModel _cart = CartModel();

  @override
  Widget build(BuildContext context) {
    return (_cart.cart == null)
        ? "Nothing to show".text.xl3.make().centered()
        : ListView.builder(
            itemCount: _cart.cart.cartItem.length,
            itemBuilder: (context, index) => ListTile(
              leading: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  _cart.cart.decrementItemFromCart(index);
                  setState(() {
                    //totalprice = _cart.cart.getTotalAmount();
                  });
                  //widget.update();
                  msgToast(
                      '${_cart.cart.cartItem[index].productDetails.dish_name} removed from the cart');
                },
              ),
              trailing:
                  '${_cart.cart.cartItem[index].quantity} * \₹${_cart.cart.cartItem[index].unitPrice}'
                      .text
                      .lg
                      .color(Color(0xff403b58))
                      .make(),
              title: '${_cart.cart.cartItem[index].productDetails.dish_name}'
                  .text
                  .color(Color(0xff403b58))
                  .make(),
            ),
          );
  }
}

class _CartTotal extends StatefulWidget {
  // final totalprice;
  //
  // const _CartTotal({Key key, this.totalprice}) : super(key: key);

  @override
  __CartTotalState createState() => __CartTotalState();
}

class __CartTotalState extends State<_CartTotal> {
  final CartModel _cart = CartModel();

  var totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      totalprice = _cart.cart.getTotalAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          "\₹${totalprice}".text.xl5.color(Color(0xff403b58)).make(),
          30.widthBox,
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              30.widthBox,
              ElevatedButton(
                onPressed: () {
                  // Scaffold.of(context).showSnackBar(SnackBar(content: "Buying not supported yet".text.make()));
                  msgToast('價格已更新');
                  setState(() {
                    totalprice = _cart.cart.getTotalAmount();
                  });
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff403b58))),
                child: "更新價格".text.white.make(),
              ).w32(context),
              // 100.widthBox,
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: "尚未支援結帳功能".text.make()));
                  setState(() {
                    totalprice = _cart.cart.getTotalAmount();
                  });
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff403b58))),
                child: "結帳".text.white.make(),
              ).w32(context),
            ]),
          ),
        ],
      ),
    );
  }
}
