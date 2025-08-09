import 'package:flutter/material.dart';

class HomeProfileContent extends StatelessWidget {
  final dynamic controller;
  const HomeProfileContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tu perfil",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 16),

          // Foto + nombre + fecha cliente
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage("data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQDw8QDg8NEA4PDw4PDw0QDw8NDg0NFRUWFhURFRUYHSggGBomGxUVITEhJSkrLi4uFx8zODMtNygtLi0BCgoKDg0OGxAQGi0lICUyKy0rLS0tKystNy8tKy0tKzctLS0uLS0rLi0rKysrLy0tLS0tLS0tLy4tLS0rNS0tK//AABEIAOEA4QMBIgACEQEDEQH/xAAcAAEAAgMBAQEAAAAAAAAAAAAAAQUEBgcDAgj/xAA+EAACAQIDBQYCBwcEAwEAAAAAAQIDEQQSIQUxQVFxBhMiYYGRMrEHQlJygqHBFCMzYpLR4UNTk6IkssIV/8QAGQEBAAMBAQAAAAAAAAAAAAAAAAECBAMF/8QAKBEBAAICAQMDAwUBAAAAAAAAAAECAxEhBBIxEyJBMnHwFEJR4fFh/9oADAMBAAIRAxEAPwDuIBAEggASCABIIAAAASCAAAAAAASCCQIAAEggASAAAAAAAAAAABAEkEgAAAAAAEByS1ei5mBiNpwjpG8n7R9wtWs28LA+ZzS3tLq0iiq7QqS45Vyjp+e8xm76vV83qw716afmV/LHUl9del5fI83tOlzf9LKMEukdNVeLadLnL+ln3HH0n9deqa+ZQAE9NVs0KkZfDKL6NM+zVkZFLHVI7pNrlLxBS3TT8S2AkraG1YvSayvmtUWEJpq6aafFaohntS1fMPoABUAAAAAAAAAAAAgCQAAAAAxcXjY09N8vsr9eRjY/aFrxp/Fxly8l5lS2GnFg3zZ7YjFTqPxPThFaJHiAS2RERGoAAEgOYdvu21VVZ4XBVHTjTbhWrwdqk6i0lCEvqpbm1rdcEtefVKspPNOc5S+1KTlK/O71KTeIUmz9IA4PsXtXjcJJOnXnOF9aFWUqtKS5JN3j+Fo7H2Z27Tx2HVamsrTcKtJu7pVUk3G/FWaafJroTW0SmLbWoALLB6UK8oO8Xby4PqjzARMRPErzB7QjPSXhly4PoZpqxZYDaNrRqPThN8Ov9yGTLg1zVbghEhlAAAAAAAACCQBBIAArdp423gg/F9Z8ly6mRtDFd3HT4npFfqUDYacGLfukABLaAAASjzr1owjKc5KMIRcpSe6MVq2cr7S9qMViZyVGc6OH3RpwlknNc5yWt/JO3XeUteKmmmbSw1SlXrU6qfewqTjO97uV34vXf6ngoPk/ZllKEuKlfnqz5s+T9jP3K+mr3F8n7M6b9DtCap4yo791OdGEFw7yCm5v2nA0Eztm7YxOGd6FepTV75L5qb6wfhfsWrfUkU1LugNU7I9sY4tqjXjGnibeFxv3Va2/Lf4Zfy+3ltZoiYnwsAAkAABZbMxtrQm9N0Xy8uhbmrF1svFZllk/FHj9qJDHnxa90M8ABlAAAAAAgkgCSJOyu9y4klftevlhlW+f/qt4WrXunSsxdfvJuXDdFconiAS9OIiI1AAAkAAGn/SVtLuqFKjd/v5ycrcYU7O39Uo+xzn9qjyl7I2/6V/4uE5d3W980L/oU/Yzs/HFznOrfuaWVW/3Kj1y9EtX1XmZM1tTMytCmli+S9zwnVlLe9OW5HT8T2Qw01bu6ceUqadJ/lv9blZP6P6d9K1W3K8H/wDJwjLC0xLQYyty9VcyIYiPGKXRI3qj2JoQ+KFWr96pp7QsY+N7I4eSap56M+Gspxv5qTv7ND1qnbLVKWKSalGTjKLUoyV04yWqa9TsWwNorE4ajWVrzjaVtyqRbjP80zi+0tn1MPUdOotd8ZLWM480zpH0XVW8FUi/qYmaXRwpy+bZpw25VluAANKoAAB90ajhJSW9P38j4ARMbbNSqKUVJbmrn2Vexq++D+9H9UWhDzb17baAAFAAAACAJKDadXNUlyj4V6b/AMy9nKyb5Jv2NZbvq971fUNPTV5mUAAltAAAAAGkfSphM1DD1kv4dWUH5RqRvf3gvc9ewlJU8BGVnec6k3ZXb1svySLXtd3dTDVcNL46sPButGonem3r9pI13s5tWqqeGwlKiozdJSdWrmUF4VJ2ileXLetTB1MxM6h3xYrX8fdc4vF45P8Ac4OjKP8APioxqeqy2XpJmfgKtaUL16UaU7/BGr32nO9kYOPrVaFGpWr4mjGFKLlNxwst3JLvG272XqYlLblT9np4tOnicNUaX7unKhXi3LIllcpKTz+FrT1M+tx4Wrj7rdtbRM/wvMXOpGDdKnGpNboSqd0n+KzKmlicfN2q4HDqHH/ylmt5Wi9fYjC7WrYipKEIPCqlFTqyrwzVLO+VRjdJLR6v2PnYe0I42E6mGxteUYTcJXo0IWlZNOzhuaaYiOPCb4uye20xE/x/jD7W7J77CynGMlOknUUZJZ4W+KLto1blyRl/RhRy4GUv9zEVJLoowj84sna20q2FdNVEsTSrZoZYw7usmkuV1LR7rIyux9WnRw2HwqzKcYXknb+JNuck9d95M0dNaKzzP2Vy4bVrFviWxgA3s4AAAAA9cLVyTjLk9ej0ZsiNWNiwc81OD/lV+q0ZDJ1NfEvcABkAQSAIJAGNtCVqU+lvfQ18vNrP90+sfmUZLb00e0AAaQAAAABrHaih48zvrFW+TS8zxqTyRoVX8FCteo7fDSqQcHLom4t+SZtVajGatOKkt+vMr8VFQqrRKE4KNraXWlvl7nn58M1mb/Dvjya0we0WzP2zB1qEZJd7GLhPfFSjJTi3bheKKvYWy+4pYXA5lUeHk8RiZrWEZuUqkKa/HJNeUL6XLn/8jD8KUY8bQcqcb9ItI+pYejCDpx7ulBu7issU3fVtcbnDunWoWrFIt3V3tjbVioTVaV+6lTnh8RJa5KctY1OkXdPkpt8Cv7DdnpYChVjOrTqyq1M6nTvk7tK0d/F6t9ba2uXWEjTjdRnB5uCcbeyPh7Hwr1eGw+ru/wB1DV+wi0xGiYrMxNt7h406qrYpSg1Klh6dSLmtYyrzcfCnxyxi7/eRh7HoZsRdXuqjlfd4d7ubBRgllikktyikkkuhlUqEIXyRjG++ysdcOGbz3fEIvljxD0AB6TOAAAAABd7IlenblJr9f1KQt9iPwz+9+gcOoj2LIAEMACCQBBIAwtrfwn1j8yjL/aUb0p9E/Z3KAlt6afaAANIAAAAAGPjsP3kLL4lrHryMgFbVi0akidKnC17+GWk1z4/5POeFhGcpvDUcRGo06lOdoVMyVs8J8HZK6e+y3cczH4HP44aTXpm/yYKxO+FWPk9PmjzZi+CztE7fcqFKayxwVHD03bM5Zataovs6aRjz3t7tDKk7avdzMSFalTTyXtve9v1bKSl2rw88ZSoSeanKWXvE13Uar+BP7Sb0vu1XmRNrZbE/n5La8HBvxvS6tBccvP1MoA9KlIpXUOMzsABcAAAAAAt9irwz+8vkVBdbHj+7b5yb+S/QOHUfQzwAQwAIJAAEAfNWF4yXNNe6NZsbQa/tCllqSXB+JdH/AJuS1dNbmYY4ADYAAAAAABR7W7V4TD3Wfvai/wBOlabT85fCve/kTWs2nUQLw1vaNDNUnKMnGWZq61Uraar0NT2v2xxNe8abVCm9MtNvvGvOpv8AaxY7C2/CpFU60lGqtMztGNXzvuUvL28ufWdNk9OJ06UjTJxGBrTTjKUXFpp6tKz8rHNatNxcoSWsXKMl5p2aOm7V2xSoRd2pVLeGkndt83yRzvaEpTnOrK2acnKVlZXfIy4OnyTSb64Tbl1HsLt/9rw+SpK+IoJRqX31IfVqfo/NeaNmOIdmtpPC4ujWvaKkoVeToy0lfp8XWKO3JppNNNPVNO6a5pmnHbcOUpAB0AAAAAANhwNPLTgvK/vr+pRUKeacY82vbibIgydTbxCQAQyAAAEEgCCu2zRvFTX1dH91/wCSyPmcU009zTT6Balu20S1gHpiKLhJxfDc+a4M8yXpxO43AAAkKrtBtyng6eafiqSuqdJOzm1vbfCK0uy1OS9scc62Nru940pOjBcEoaP/ALZn6nbBj77cpiHltXtFicS5KpVkoP8A0abcKSXJpfF63Ks8aL19D2PQpEa4XrO4AAXSBoAjyMFoutk7axGGyujVlFf7bealJ8bwenrv8ymqfE+rPZrwx6HldHGr2j4/tTenXOzHaSGMi4yShiIK8qd/DKP24eXlwv6l8cW2Nj3QrUaydu7nFy84bpr1jc7SdM+OKTuPEomAAHBAAfUIOTSW9uyCFjsajq5vh4V14lseWHpKEVFcF7viz1Iebkv3W2AAKAAAEEgAAAMHaeFzxzL4o/muRSG0lRtPBWvOC03yXLzDVgy69sq0AEtj5nNRTk90U5PotTh1eo55pPfNuT6t3fzOx9oauTB4qS3qhVt1cWl8zjclo+ht6WOJlaPEvGlv9z3PCnvR7mmngx+AAF1wN215AiUb793zK23rgYtKGZ+XE9q3A9Ujxrb/AEM+LBGKv/Z8qW4h90t3udo2FX7zC4ab3yoUm/vZUn+dzjFLcdX7DVc2Ao84urD2nK35NEdTHsiT9sL4AGFULbZOFsu8ktX8K5LmY2zsHneaS8C/7Pl0LuwZM+X9sJABDIAAAAAAAAAAAQyQBUY/Z9ryprTjFcPNeRWm0mBjNnKesLRlx+zL+wasWfXFmkdt6mXZ+I8+6j71Ip/kcpO4bQwKnCdGvC8JpxlF8VzT/VHMdpdlKkKk40ZxnBSaWd5Z24X0s+uhqw58eONXnTdSdxw1VaPozINh2f2IxVWcZSdGFLPFTbqPPlus2VJPW3Q1vvLNqWjTafVGrHkrbxKKz28S+wQpLmiTq6ABDkuaBtJ4Vd7Pt1Vw/sbA+xuJlSp4iDoyp1KVGrZzcakXKMW001be3xOWS9YjmXO074hRxWh0j6N6l8JUX2cRNejhB/3NUw3ZetKSU5U4Ruru+eXol/c6ZsfZcMPTjQoRbSu775Tk98peZmzdRjvXtpO1r8QyjNwGBc/FLSHs5f4MnB7MtaVSzf2eC68yyRlYcuf4qRikrLRLcuRIBDIAAAAAAAAAAAAAAAAAAD4qUoyVpJNeZru0+y+aUp0Z2b1cJ7r+UkbKCl8dbxqzpjy2pPtlqWDwNWjC1SDTzPXSS90cS2xTyYrEx+ziK69FOVj9NFRtLsxgcS3KvhMPOct9TIoVH+ONpfmdsFoxxp2/U7+qH5wJO3Yn6Ldmy+BYml9yu52/5FIr5fRFhfq4vGfi7iXygjV69F4z0chIOvx+iLC8cXi/RUY/OLM3DfRXs6PxvF1eeesoX/44xHr0PXo4lN6Pozu1LAzeHjTpwcnGlCCS3aJLe9OBabO7HbOw9nSwdC63TqRdea/FUbZeWM+a8ZI0p+p14hquz+y0rqVeaVmnkhq/WRs1GhGCtFJfN+p6gzY8daRqrjky3yfVIADo5gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/9k="),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jazmín Pérez",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                  Text("Cliente desde: Junio 2022",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
                ],
              )
            ],
          ),
          const SizedBox(height: 24),

          // Información personal
          _infoCard(
            context,
            title: "Información personal",
            items: [
              _infoItem(context, "Nombre completo", "Jazmín Pérez López"),
              _infoItem(context, "Correo electrónico", "Jazmín.perez@example.com"),
              _infoItem(context, "Teléfono", "+52 55 1234 5678"),
            ],
          ),
          const SizedBox(height: 16),

          // Información financiera
          _infoCard(
            context,
            title: "Información financiera",
            items: [
              _infoItem(context, "CLABE", "•••• •••• •••• •••• 7890"),
              _infoItem(context, "Límite de crédito", "\$25,000.00 MXN"),
              _scoreItem(context, "Score crediticio", 0.75, "750"),
            ],
          ),
          const SizedBox(height: 16),

          // Botón editar perfil
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Acción de editar perfil
              },
              child:  Text("Editar perfil",
                  style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primaryContainer)),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoCard(
      BuildContext context, {required String title, required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.onInverseSurface, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                   TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          ...items
        ],
      ),
    );
  }

  Widget _infoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Theme.of(context).colorScheme.onSurface))
        ],
      ),
    );
  }

  Widget _scoreItem(BuildContext context, String label, double progress, String scoreText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer , //esaul
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(scoreText,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12))
            ],
          )
        ],
      ),
    );
  }
}
