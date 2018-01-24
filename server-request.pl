#!/usr/bin/perl -w

# Первая строка - "#!/usr/bin/perl -w" - дань юниксовому прошлому. На этих платформах командный интерпретатор (aka shell), 
# перед тем как запустить на исполнение текстовый файл, читает из него первую строку. 
# Если она начинается с символов #!, то shell берёт всё, что следует за этими символами (а это обычно путь до интерпретатора), 
# добавляет к получившейся строке имя файла и исполняет.

# По умолчанию Perl выводит сообщения только об ошибках, а с параметром -w ещё и предупреждения, 
# что бывает крайне полезно в процессе разработки программы.

use IO::Socket;

# Этот модуль служит для использования сокетов в Perl. 
# Выражаясь абстрактно, сокеты — это конечные точки потока данных который протекает между двумя компьютерами. 
# Таким образом, c помощью данного модуля, вы можете отправлять и принимать пакеты используя любые протоколы (даже можете придумать свой).

use File::Basename;

sub Request {
 my ($host, $resource, $method, $data) = @_;

 my $sock = new IO::Socket::INET(PeerAddr => $host, PeerPort => '80', Proto => 'tcp');
 die "Не удалось создать сокет: $!\n" unless $sock;

 print $sock "$method $resource HTTP/1.0\r\n";
 print $sock "Host: $host\r\n";
 
 if ($method eq 'POST' && length $data) {
  print $sock "Content-Type: application/x-www-form-urlencoded\r\n";
  my $content_length = length $data;
  print $sock "Content-Length: $content_length\r\n";
 }

 # После объявления последнего заголовка последовательность символов для переноса строки добавляется дважды.
 print $sock "\r\n";
 
 if ($method eq 'POST' && length $data) {
  print $sock "$data\r\n";
  print $sock "\r\n";
 }

 my $resource_header_file_name = "Заголовок ответа на $method-запрос.txt",
    $resource_header_file_handler = undef,
    $resource_content_file_name = fileparse($resource),
    $resource_content_file_handler = undef;

 open($resource_header_file_handler, '>', $resource_header_file_name)
  or die "Не получается создать файл '$resource_header_file_name' $!";

 open($resource_content_file_handler, '>', $resource_content_file_name)
  or die "Не получается создать файл '$resource_content_file_name' $!";

 # Функция open принимает 3 параметра. Первый это скалярная переменная.
 # Второй параметр определяет, каким образом мы открываем файл. 
 # В данном случае мы поставили знак "больше" (>), что значит, что файл открывается для записи.
 # Третий параметр - путь к файлу, который мы хотим открыть.
 # Когда эта функция вызывается, она присваивает скалярной переменной специальный ключ,
 # который называется указателем файла (file-handle).
  
 while ($response_line = <$sock>) {
  print $resource_header_file_handler $response_line;
  if ("$response_line" eq "\r\n") {
   last;
  }
 }

 while ($response_line = <$sock>) {
  print $resource_content_file_handler $response_line;
 }

 close $resource_header_file_handler;
 close $resource_content_file_handler;

 close($sock);
}

Request('www.kernel.org', '/index.html', 'HEAD');

Request('www.perl.org', '/index.html', 'GET');

Request('groggory.com', '/demos/demo_post.php', 'POST', 'fname=John&lname=Smith&submit=Submit');
