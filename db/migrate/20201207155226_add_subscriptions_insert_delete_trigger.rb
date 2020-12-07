class AddSubscriptionsInsertDeleteTrigger < ActiveRecord::Migration[6.0]
  def up
    add_column(:programs, :subscriptions_count, :integer, default: 0)
    execute <<-SQL
      CREATE OR REPLACE FUNCTION count_subscriptions() RETURNS TRIGGER AS
      '
        BEGIN
          IF TG_OP = ''INSERT'' THEN
            UPDATE programs
              SET subscriptions_count = subscriptions_count + 1
              WHERE id = NEW.program_id;
          ELSIF TG_OP = ''DELETE'' THEN
            UPDATE programs
              SET subscriptions_count = subscriptions_count - 1
              WHERE id = OLD.program_id;
          END IF;
          RETURN NULL;
        END;
      ' LANGUAGE plpgsql;
    SQL
    ActiveRecord::Base.transaction do
      execute <<-SQL
        LOCK TABLE programs IN SHARE ROW EXCLUSIVE MODE;
        CREATE TRIGGER count_subscriptions_trigger AFTER INSERT OR DELETE ON subscriptions FOR EACH ROW EXECUTE PROCEDURE count_subscriptions();
        UPDATE programs SET subscriptions_count = (SELECT COUNT(user_id) FROM subscriptions WHERE program_id = programs.id);
      SQL
    end
  end

  def down
    execute "DROP TRIGGER count_subscriptions_trigger ON subscribtions"
    execute "DROP FUNCTION count_subscriptions()"
    remove_column(:programs, :subscriptions_count)
  end
end
