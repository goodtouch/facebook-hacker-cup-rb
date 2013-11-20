# A sample Guardfile
require 'benchmark'
require 'timeout'

last_time = nil

# notification :notifysend

guard :shell do
  watch /(.rb|.in|.out)/ do |m|
    if last_time.nil? || Time.now - last_time > 3
      filename = m[0]
      basedir  = File.dirname(__FILE__)
      dirname  = File.dirname(filename)
      extname  = File.extname(filename)
      basename = File.join(basedir, dirname, File.basename(filename, extname))

      quick_out = `cat #{basename}.in | ruby #{basename}.rb`.split("\n")
      ref_out = File.read("#{basename}.out").split("\n")
      res = []

      ref_out.each_with_index do |line, i|
        if line != quick_out[i]
          res << "Line #{i}: expected [#{line}] was [#{quick_out[i]}]"
        end
      end
      quick_out.each_with_index do |line, i|
        next if i < ref_out.size
        res << "Line #{i}: expected [] was [#{quick_out[i]}]"
      end

      if res.empty?
        n "Benchmarking", "OK"

        out      = []
        times    = []
        timeouts = []

        ENV['QUERY_OPTIONS'] = "true"
        algos, timeout = `ruby #{basename}.rb`.split.map(&:to_i)
        ENV.delete('QUERY_OPTIONS')
        1.upto(algos) do |i|
          STDERR.puts "Computing with algo #{i}..."
          t = Benchmark.measure do
            ENV['ALGO']=i.to_s
            if timeout
              begin
                Timeout::timeout(timeout) { out << `cat #{basename}.in | ruby #{basename}.rb`.split("\n") }
              rescue Timeout::Error
                timeouts[i-1] = true
                out << "Timeout"
                times << "  Timeout\n"
              end
            else
              out << `cat #{basename}.in | ruby #{basename}.rb`.split("\n")
            end
          end
          STDERR.puts "Algo #{i}: #{t}"
          times << t unless timeouts[i-1]
        end

        0.upto(algos - 1) do |a|
          unless timeouts[a]
            ref_out.each_with_index do |line, i|
              if line != out[a][i]
                res << "Algo #{a+1} | Line #{i}: expected [#{line}] was [#{out[a][i]}]"
              end
            end
          end
        end

        if res.empty?
          o = []
          times.each_with_index{|t, i| o << "algo #{i+1}: #{t}" }
          n o.join, "OK"
        else
          n res.join("\n"), "KO"
        end
      else
        n res.join("\n"), "KO"
      end
      last_time = Time.now
    else
      STDERR.puts "Ignoring"
    end
  end
end
