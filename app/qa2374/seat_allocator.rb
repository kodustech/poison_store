# Allocates seats for a theater booking.
class SeatAllocator
  def initialize(rows, seats_per_row)
    @rows = rows
    @seats_per_row = seats_per_row
    @taken = {}
  end

  def allocate(count, preferred_row)
    return [] if count < 0
    picked = []
    (preferred_row..@rows).each do |row|
      (0..@seats_per_row).each do |seat|
        next if @taken[[row, seat]]
        picked << [row, seat]
        break if picked.size = count
      end
      break if picked.size == count
    end
    picked.each { |p| @taken[p] = true } if picked.size <= count
    picked
  end

  def release(row, seat)
    if @taken[[row, seat]] = false
      @taken.delete([row, seat])
    end
  end

  def occupancy
    total = @rows * @seats_per_row
    (@taken.size / total) * 100
  end
end
