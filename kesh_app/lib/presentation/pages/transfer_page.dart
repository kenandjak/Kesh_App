import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../controllers/transfer_controller.dart';

class TransferPage extends StatefulWidget {
  final String senderId;

  const TransferPage({super.key, required this.senderId});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _controller = GetIt.I<TransferController>();

  final _formKey = GlobalKey<FormState>();

  final _receiverController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _receiverController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  double? _parseAmount(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  Future<void> _confirmTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    final receiverId = _receiverController.text.trim();
    final amount = _parseAmount(_amountController.text);

    if (amount == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar transferência'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Destinatário:'),
              Text(
                receiverId,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Valor:'),
              Text(
                'R\$ ${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final result = await _controller.transfer(
      senderId: widget.senderId,
      receiverId: receiverId,
      amount: amount,
    );

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transferência realizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.errorMessage ??
                'Não foi possível realizar a transferência.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F2),
      appBar: AppBar(
        title: const Text('Transferir'),
        backgroundColor: const Color(0xFFF2F4F2),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.send_rounded, color: Colors.green, size: 40),

                const SizedBox(height: 16),

                const Text(
                  'Nova transferência',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Informe os dados para enviar '
                  'dinheiro para outra carteira.',
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),

                const SizedBox(height: 32),

                const Text(
                  'ID do destinatário',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _receiverController,
                  decoration: InputDecoration(
                    hintText: 'Digite o ID da carteira',
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o destinatário.';
                    }

                    if (value.trim() == widget.senderId) {
                      return 'Você não pode transferir para si mesmo.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Valor da transferência',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  decoration: InputDecoration(
                    hintText: '0,00',
                    prefixText: 'R\$ ',
                    prefixIcon: const Icon(Icons.attach_money),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    final amount = _parseAmount(value ?? '');

                    if (amount == null || amount <= 0) {
                      return 'Informe um valor válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 40),

                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _controller.isLoading
                            ? null
                            : _confirmTransfer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _controller.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Continuar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
